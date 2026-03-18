extends Node
# EmailSender — auto-sends booking email via Google Apps Script webhook
# Simple HTTP POST — no API keys, no signup, just works!

const WEBHOOK_URL = "https://script.google.com/macros/s/AKfycbxEzNunueT5fBYb8caITwmlTkLWp-hjPLh_R18WgbAAvQmRJ79D2CKiAJQ_LZzqLG3Y/exec"
const RECIPIENT_EMAIL = "bhavyat81@gmail.com"

var _http_request: HTTPRequest = null

func _ready() -> void:
	_http_request = HTTPRequest.new()
	add_child(_http_request)
	_http_request.request_completed.connect(_on_request_completed)

func send_booking_email(booking: BookingData) -> void:
	var payload = {
		"to_email": RECIPIENT_EMAIL,
		"subject": "New Ride Booking - " + booking.booking_reference + " - Jo's Ride Share",
		"booking_reference": booking.booking_reference,
		"selected_date": booking.selected_date,
		"route": booking.route,
		"departure_time": booking.departure_time,
		"passenger_name": booking.name,
		"phone": booking.phone,
		"email": booking.email,
		"num_bags": str(booking.num_bags),
		"pickup_address": booking.pickup_address,
		"dropoff_address": booking.dropoff_address,
	}

	var json_body = JSON.stringify(payload)
	var headers = ["Content-Type: application/json"]

	print("[EmailSender] Sending booking email to ", RECIPIENT_EMAIL)
	print("[EmailSender] Payload: ", json_body)

	var error = _http_request.request(WEBHOOK_URL, headers, HTTPClient.METHOD_POST, json_body)
	if error != OK:
		print("[EmailSender] ERROR: Failed to send HTTP request: ", error)
	else:
		print("[EmailSender] HTTP request sent, waiting for response...")

func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		print("[EmailSender] ❌ Network error (result=", result, ")")
		return
	var response_text = body.get_string_from_utf8()
	if response_code == 200 or response_code == 302:
		print("[EmailSender] ✅ Email sent successfully to ", RECIPIENT_EMAIL)
		print("[EmailSender] Response: ", response_text)
	else:
		print("[EmailSender] ❌ Email failed. Code: ", response_code, " Response: ", response_text)
