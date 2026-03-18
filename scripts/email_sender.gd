extends Node
# EmailSender: Autoload helper for sending booking details via mailto

func send_booking_email(booking: BookingData) -> void:
	var subject = "New Booking " + booking.booking_reference + " - Jo's Ride Share"
	var body = _build_email_body(booking)
	var encoded_subject = subject.uri_encode()
	var encoded_body = body.uri_encode()
	var mailto_url = "mailto:josemon619@gmail.com?subject=" + encoded_subject + "&body=" + encoded_body
	print("[EmailSender] Opening mailto: ", mailto_url)
	OS.shell_open(mailto_url)

func _build_email_body(booking: BookingData) -> String:
	var lines: Array[String] = []
	lines.append("Jo's Ride Share — Booking Confirmation")
	lines.append("=========================================")
	lines.append("")
	lines.append("Booking Reference: " + booking.booking_reference)
	lines.append("Date: " + booking.selected_date)
	lines.append("Route: " + booking.route)
	lines.append("Departure: " + booking.departure_time)
	lines.append("")
	lines.append("Passenger Details")
	lines.append("-----------------")
	lines.append("Name: " + booking.name)
	lines.append("Phone: " + booking.phone)
	lines.append("Email: " + booking.email)
	lines.append("Number of Bags: " + str(booking.num_bags))
	lines.append("Pickup Address: " + booking.pickup_address)
	lines.append("Drop-off Address: " + booking.dropoff_address)
	lines.append("")
	lines.append("Thank you for choosing Jo's Ride Share!")
	lines.append("Windsor \u2194 Toronto Daily Service")
	return "\n".join(lines)
