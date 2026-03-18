extends Node
# EmailSender — auto-sends booking confirmation email via EmailJS REST API

const EMAILJS_URL = "https://api.emailjs.com/api/v1.0/email/send"
# NOTE: Replace these with your own EmailJS credentials (see README for setup instructions)
const EMAILJS_SERVICE_ID  = "YOUR_SERVICE_ID"   # e.g. "service_abc123"
const EMAILJS_TEMPLATE_ID = "YOUR_TEMPLATE_ID"  # e.g. "template_xyz456"
const EMAILJS_PUBLIC_KEY  = "YOUR_PUBLIC_KEY"   # e.g. "user_XXXXX"
const RECIPIENT_EMAIL     = "josemon619@gmail.com"

var _http_request: HTTPRequest = null

func _ready() -> void:
	_http_request = HTTPRequest.new()
	add_child(_http_request)
	_http_request.request_completed.connect(_on_request_completed)

func send_booking_email(booking: BookingData) -> void:
	var body_text = _format_booking_body(booking)

	var template_params = {
		"to_email":          RECIPIENT_EMAIL,
		"subject":           "New Ride Booking - " + booking.booking_reference,
		"booking_reference": booking.booking_reference,
		"passenger_name":    booking.name,
		"phone":             booking.phone,
		"email":             booking.email,
		"route":             booking.route,
		"departure_time":    booking.departure_time,
		"selected_date":     booking.selected_date,
		"num_bags":          str(booking.num_bags),
		"pickup_address":    booking.pickup_address,
		"dropoff_address":   booking.dropoff_address,
		"message":           body_text,
	}

	var payload = {
		"service_id":      EMAILJS_SERVICE_ID,
		"template_id":     EMAILJS_TEMPLATE_ID,
		"user_id":         EMAILJS_PUBLIC_KEY,
		"template_params": template_params,
	}

	var json_body = JSON.stringify(payload)
	var headers = [
		"Content-Type: application/json",
		"origin: http://localhost",
	]

	print("[EmailSender] Sending booking email to ", RECIPIENT_EMAIL)
	print("[EmailSender] Booking details: ", body_text)

	var error = _http_request.request(EMAILJS_URL, headers, HTTPClient.METHOD_POST, json_body)
	if error != OK:
		print("[EmailSender] ERROR: Failed to send HTTP request: ", error)
	else:
		print("[EmailSender] HTTP request sent, waiting for response...")

func _format_booking_body(booking: BookingData) -> String:
	var lines: Array[String] = []
	lines.append("=== Jo's Ride Share — New Booking ===")
	lines.append("")
	lines.append("Booking Reference: " + booking.booking_reference)
	lines.append("Date: " + booking.selected_date)
	lines.append("Route: " + booking.route)
	lines.append("Departure: " + booking.departure_time)
	lines.append("")
	lines.append("--- Passenger Details ---")
	lines.append("Name: " + booking.name)
	lines.append("Phone: " + booking.phone)
	lines.append("Email: " + booking.email)
	lines.append("Bags: " + str(booking.num_bags))
	lines.append("")
	lines.append("--- Addresses ---")
	lines.append("Pickup: " + booking.pickup_address)
	lines.append("Drop-off: " + booking.dropoff_address)
	lines.append("")
	lines.append("=== End of Booking ===")
	return "\n".join(lines)

func _on_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		print("[EmailSender] ❌ Network error (result=", result, "). Email was not delivered.")
		return
	if response_code == 200:
		print("[EmailSender] ✅ Email sent successfully to ", RECIPIENT_EMAIL)
	else:
		var response_text = body.get_string_from_utf8()
		print("[EmailSender] ❌ Email failed. Code: ", response_code, " Response: ", response_text)
