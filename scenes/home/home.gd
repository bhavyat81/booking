extends Control
# Home Screen — displays the two available routes

func _ready() -> void:
	pass

func _on_windsor_to_toronto_pressed() -> void:
	var booking = BookingData.new()
	booking.route = BookingData.ROUTE_WINDSOR_TO_TORONTO
	booking.departure_time = BookingData.DEPARTURE_WINDSOR
	SceneManager.go_to_booking_form(booking)

func _on_toronto_to_windsor_pressed() -> void:
	var booking = BookingData.new()
	booking.route = BookingData.ROUTE_TORONTO_TO_WINDSOR
	booking.departure_time = BookingData.DEPARTURE_TORONTO
	SceneManager.go_to_booking_form(booking)
