extends Control
# Booking Form Screen — collects booking details from the user

@onready var route_label: Label = $ScrollContainer/FormContainer/RouteLabel
@onready var name_input: LineEdit = $ScrollContainer/FormContainer/NameInput
@onready var phone_input: LineEdit = $ScrollContainer/FormContainer/PhoneInput
@onready var email_input: LineEdit = $ScrollContainer/FormContainer/EmailInput
@onready var bags_value: Label = $ScrollContainer/FormContainer/BagsRow/BagsValue
@onready var pickup_input: LineEdit = $ScrollContainer/FormContainer/PickupInput
@onready var dropoff_input: LineEdit = $ScrollContainer/FormContainer/DropoffInput
@onready var date_input: LineEdit = $ScrollContainer/FormContainer/DateInput
@onready var error_label: Label = $ScrollContainer/FormContainer/ErrorLabel

var _bags_count: int = 0
var _booking: BookingData = null

func _ready() -> void:
	_booking = SceneManager.current_booking
	if _booking == null:
		SceneManager.go_home()
		return
	route_label.text = _booking.route + "  ·  Departure: " + _booking.departure_time
	bags_value.text = str(_bags_count)
	error_label.text = ""
	error_label.hide()

func _on_bags_minus_pressed() -> void:
	if _bags_count > 0:
		_bags_count -= 1
		bags_value.text = str(_bags_count)

func _on_bags_plus_pressed() -> void:
	if _bags_count < 10:
		_bags_count += 1
		bags_value.text = str(_bags_count)

func _on_back_pressed() -> void:
	SceneManager.go_home()

func _on_book_now_pressed() -> void:
	if not _validate():
		return
	_booking.name = name_input.text.strip_edges()
	_booking.phone = phone_input.text.strip_edges()
	_booking.email = email_input.text.strip_edges()
	_booking.num_bags = _bags_count
	_booking.pickup_address = pickup_input.text.strip_edges()
	_booking.dropoff_address = dropoff_input.text.strip_edges()
	_booking.date = date_input.text.strip_edges()
	_booking.generate_reference()

	# Log booking to console for testing
	print("Booking submitted: ", _booking.to_dict())

	SceneManager.go_to_confirmation(_booking)

func _validate() -> bool:
	var errors: Array[String] = []
	if name_input.text.strip_edges().is_empty():
		errors.append("Name is required.")
	if phone_input.text.strip_edges().is_empty():
		errors.append("Phone number is required.")
	if email_input.text.strip_edges().is_empty():
		errors.append("Email is required.")
	elif not _is_valid_email(email_input.text.strip_edges()):
		errors.append("Please enter a valid email address.")
	if pickup_input.text.strip_edges().is_empty():
		errors.append("Pickup address is required.")
	if dropoff_input.text.strip_edges().is_empty():
		errors.append("Drop-off address is required.")
	if date_input.text.strip_edges().is_empty():
		errors.append("Date is required.")

	if errors.is_empty():
		error_label.hide()
		return true
	else:
		error_label.text = "\n".join(errors)
		error_label.show()
		return false

func _is_valid_email(email: String) -> bool:
	var at_pos = email.find("@")
	if at_pos < 1:
		return false
	var dot_pos = email.rfind(".")
	return dot_pos > at_pos + 1 and dot_pos < email.length() - 1
