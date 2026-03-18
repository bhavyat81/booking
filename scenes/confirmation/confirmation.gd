extends Control
# Confirmation Screen — shows booking summary and reference number

@onready var reference_label: Label = $ScrollContainer/ContentContainer/ReferenceLabel
@onready var route_value: Label = $ScrollContainer/ContentContainer/SummaryGrid/RouteValue
@onready var departure_value: Label = $ScrollContainer/ContentContainer/SummaryGrid/DepartureValue
@onready var date_value: Label = $ScrollContainer/ContentContainer/SummaryGrid/DateValue
@onready var name_value: Label = $ScrollContainer/ContentContainer/SummaryGrid/NameValue
@onready var phone_value: Label = $ScrollContainer/ContentContainer/SummaryGrid/PhoneValue
@onready var email_value: Label = $ScrollContainer/ContentContainer/SummaryGrid/EmailValue
@onready var bags_value: Label = $ScrollContainer/ContentContainer/SummaryGrid/BagsValue
@onready var pickup_value: Label = $ScrollContainer/ContentContainer/SummaryGrid/PickupValue
@onready var dropoff_value: Label = $ScrollContainer/ContentContainer/SummaryGrid/DropoffValue
@onready var invoice_label: Label = $ScrollContainer/ContentContainer/InvoiceLabel

func _ready() -> void:
	var booking = SceneManager.current_booking
	if booking == null:
		SceneManager.go_home()
		return
	reference_label.text = "Booking Reference: " + booking.booking_reference
	route_value.text = booking.route
	departure_value.text = booking.departure_time
	date_value.text = booking.date
	name_value.text = booking.name
	phone_value.text = booking.phone
	email_value.text = booking.email
	bags_value.text = str(booking.num_bags)
	pickup_value.text = booking.pickup_address
	dropoff_value.text = booking.dropoff_address
	invoice_label.text = "An invoice will be sent to " + booking.email

func _on_back_to_home_pressed() -> void:
	SceneManager.go_home()
