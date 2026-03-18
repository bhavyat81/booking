extends Control
# Booking Form -- route selection + passenger details + email notification

# -- Colour palette ----------------------------------------------------------
const C_BG        = Color(0.0588, 0.0588, 0.102)  # #0F0F1A
const C_CARD      = Color(0.102,  0.102,  0.180)  # #1A1A2E
const C_ACCENT    = Color(0.914,  0.271,  0.376)  # #E94560
const C_GOLD      = Color(1.0,    0.843,  0.0)    # #FFD700
const C_TEXT      = Color(1.0,    1.0,    1.0)    # #FFFFFF
const C_TEXT_SEC  = Color(0.533,  0.533,  0.667)  # #8888AA
const C_INPUT_BG  = Color(0.145,  0.145,  0.251)  # #252540
const C_ERROR     = Color(1.0,    0.341,  0.341)  # bright red

@onready var _bg:            ColorRect       = $Background
@onready var _topbar:        PanelContainer  = $TopBar
@onready var _back_btn:      Button          = $TopBar/TopBarContent/BackButton
@onready var _top_title:     Label           = $TopBar/TopBarContent/TopTitle
@onready var _form_vbox:     VBoxContainer   = $ScrollContainer/FormContainer
@onready var _date_lbl:      Label           = $ScrollContainer/FormContainer/DateDisplay
@onready var _select_lbl:    Label           = $ScrollContainer/FormContainer/SelectRideLbl
@onready var _passenger_lbl: Label           = $ScrollContainer/FormContainer/PassengerLbl
@onready var _name_input:    LineEdit        = $ScrollContainer/FormContainer/NameInput
@onready var _phone_input:   LineEdit        = $ScrollContainer/FormContainer/PhoneInput
@onready var _email_input:   LineEdit        = $ScrollContainer/FormContainer/EmailInput
@onready var _bags_value:    Label           = $ScrollContainer/FormContainer/BagsRow/BagsValue
@onready var _pickup_input:  LineEdit        = $ScrollContainer/FormContainer/PickupInput
@onready var _dropoff_input: LineEdit        = $ScrollContainer/FormContainer/DropoffInput
@onready var _error_lbl:     Label           = $ScrollContainer/FormContainer/ErrorLabel
@onready var _book_btn:      Button          = $ScrollContainer/FormContainer/BookNowBtn

var _bags_count: int = 0
var _selected_route: int = -1
var _booking: BookingData = null
var _route_btns: Array = []

func _ready() -> void:
	_booking = SceneManager.current_booking
	if _booking == null:
		SceneManager.go_to_calendar()
		return

	_route_btns = [
		$ScrollContainer/FormContainer/Route0Btn,
		$ScrollContainer/FormContainer/Route1Btn,
		$ScrollContainer/FormContainer/Route2Btn,
	]

	# Set route button labels from BookingData.ROUTES
	for i in range(_route_btns.size()):
		var r = BookingData.ROUTES[i]
		_route_btns[i].text = r[0] + "  " + r[1] + "  —  " + r[2]

	_apply_styles()
	_date_lbl.text = _booking.selected_date
	_bags_value.text = "0"
	_error_lbl.hide()

# -- Styling ------------------------------------------------------------------

func _apply_styles() -> void:
	_bg.color = C_BG

	# TopBar
	var topbar_style = StyleBoxFlat.new()
	topbar_style.bg_color = C_CARD
	_topbar.add_theme_stylebox_override("panel", topbar_style)
	_style_back_btn(_back_btn)
	_top_title.add_theme_font_size_override("font_size", 18)
	_top_title.add_theme_color_override("font_color", C_ACCENT)

	# Form VBox
	_form_vbox.add_theme_constant_override("separation", 12)

	# Date label
	_date_lbl.add_theme_font_size_override("font_size", 20)
	_date_lbl.add_theme_color_override("font_color", C_GOLD)

	# Section labels
	_style_section_label(_select_lbl)
	_style_section_label(_passenger_lbl)

	# Route cards
	for i in range(_route_btns.size()):
		_style_route_btn(_route_btns[i], false)

	# Input fields
	for field in [_name_input, _phone_input, _email_input, _pickup_input, _dropoff_input]:
		_style_input(field)

	# Bags row
	var bags_lbl = $ScrollContainer/FormContainer/BagsRow/BagsLabel
	bags_lbl.add_theme_font_size_override("font_size", 16)
	bags_lbl.add_theme_color_override("font_color", C_TEXT)
	_style_stepper_btn($ScrollContainer/FormContainer/BagsRow/BagsMinus)
	_style_stepper_btn($ScrollContainer/FormContainer/BagsRow/BagsPlus)
	_bags_value.add_theme_font_size_override("font_size", 20)
	_bags_value.add_theme_color_override("font_color", C_TEXT)

	# Error label
	_error_lbl.add_theme_font_size_override("font_size", 14)
	_error_lbl.add_theme_color_override("font_color", C_ERROR)

	# Book Now
	_style_accent_btn(_book_btn)
	_book_btn.add_theme_font_size_override("font_size", 20)

func _style_section_label(lbl: Label) -> void:
	lbl.add_theme_font_size_override("font_size", 18)
	lbl.add_theme_color_override("font_color", C_TEXT)

func _style_route_btn(btn: Button, selected: bool) -> void:
	var s = StyleBoxFlat.new()
	s.bg_color = C_ACCENT if selected else C_CARD
	s.corner_radius_top_left     = 14
	s.corner_radius_top_right    = 14
	s.corner_radius_bottom_right = 14
	s.corner_radius_bottom_left  = 14
	s.border_width_left   = 2
	s.border_width_top    = 2
	s.border_width_right  = 2
	s.border_width_bottom = 2
	s.border_color = C_ACCENT if selected else Color(0.2, 0.2, 0.3)
	s.set_content_margin_all(16.0)
	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   s)
	btn.add_theme_stylebox_override("pressed", s)
	btn.add_theme_stylebox_override("focus",   StyleBoxEmpty.new())
	btn.add_theme_color_override("font_color",         C_TEXT)
	btn.add_theme_color_override("font_hover_color",   C_TEXT)
	btn.add_theme_color_override("font_pressed_color", C_TEXT)
	btn.add_theme_font_size_override("font_size", 17)

func _style_input(field: LineEdit) -> void:
	var s = StyleBoxFlat.new()
	s.bg_color = C_INPUT_BG
	s.corner_radius_top_left     = 10
	s.corner_radius_top_right    = 10
	s.corner_radius_bottom_right = 10
	s.corner_radius_bottom_left  = 10
	s.set_content_margin_all(14.0)
	field.add_theme_stylebox_override("normal", s)
	field.add_theme_stylebox_override("focus",  s)
	field.add_theme_color_override("font_color",             C_TEXT)
	field.add_theme_color_override("font_placeholder_color", C_TEXT_SEC)
	field.add_theme_font_size_override("font_size", 16)

func _style_stepper_btn(btn: Button) -> void:
	var s = StyleBoxFlat.new()
	s.bg_color = C_INPUT_BG
	s.corner_radius_top_left     = 10
	s.corner_radius_top_right    = 10
	s.corner_radius_bottom_right = 10
	s.corner_radius_bottom_left  = 10
	s.set_content_margin_all(8.0)
	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   s)
	btn.add_theme_stylebox_override("pressed", s)
	btn.add_theme_stylebox_override("focus",   StyleBoxEmpty.new())
	btn.add_theme_color_override("font_color", C_ACCENT)
	btn.add_theme_font_size_override("font_size", 22)

func _style_accent_btn(btn: Button) -> void:
	var s = StyleBoxFlat.new()
	s.bg_color = C_ACCENT
	s.corner_radius_top_left     = 14
	s.corner_radius_top_right    = 14
	s.corner_radius_bottom_right = 14
	s.corner_radius_bottom_left  = 14
	s.set_content_margin_all(14.0)
	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   s)
	btn.add_theme_stylebox_override("pressed", s)
	btn.add_theme_stylebox_override("focus",   StyleBoxEmpty.new())
	btn.add_theme_color_override("font_color",         C_TEXT)
	btn.add_theme_color_override("font_hover_color",   C_TEXT)
	btn.add_theme_color_override("font_pressed_color", C_TEXT)

func _style_back_btn(btn: Button) -> void:
	var s = StyleBoxFlat.new()
	s.bg_color = Color(0, 0, 0, 0)
	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   s)
	btn.add_theme_stylebox_override("pressed", s)
	btn.add_theme_stylebox_override("focus",   StyleBoxEmpty.new())
	btn.add_theme_color_override("font_color", C_TEXT_SEC)
	btn.add_theme_font_size_override("font_size", 16)

# -- Signals ------------------------------------------------------------------

func _on_route_pressed(index: int) -> void:
	_selected_route = index
	for i in range(_route_btns.size()):
		_style_route_btn(_route_btns[i], i == index)

func _on_bags_minus_pressed() -> void:
	if _bags_count > 0:
		_bags_count -= 1
		_bags_value.text = str(_bags_count)

func _on_bags_plus_pressed() -> void:
	if _bags_count < 10:
		_bags_count += 1
		_bags_value.text = str(_bags_count)

func _on_back_pressed() -> void:
	SceneManager.go_to_calendar()

func _on_book_now_pressed() -> void:
	if not _validate():
		return
	var route_info = BookingData.ROUTES[_selected_route]
	_booking.departure_time  = route_info[1]
	_booking.route           = route_info[2]
	_booking.name            = _name_input.text.strip_edges()
	_booking.phone           = _phone_input.text.strip_edges()
	_booking.email           = _email_input.text.strip_edges()
	_booking.num_bags        = _bags_count
	_booking.pickup_address  = _pickup_input.text.strip_edges()
	_booking.dropoff_address = _dropoff_input.text.strip_edges()
	_booking.generate_reference()
	print("[BookingForm] Booking submitted: ", _booking.to_dict())
	EmailSender.send_booking_email(_booking)
	SceneManager.go_to_confirmation(_booking)

func _validate() -> bool:
	var errors: Array[String] = []
	if _selected_route == -1:
		errors.append("Please select a ride.")
	if _name_input.text.strip_edges().is_empty():
		errors.append("Full name is required.")
	if _phone_input.text.strip_edges().is_empty():
		errors.append("Phone number is required.")
	if _email_input.text.strip_edges().is_empty():
		errors.append("Email is required.")
	elif not _is_valid_email(_email_input.text.strip_edges()):
		errors.append("Please enter a valid email address.")
	if _pickup_input.text.strip_edges().is_empty():
		errors.append("Pickup address is required.")
	if _dropoff_input.text.strip_edges().is_empty():
		errors.append("Drop-off address is required.")
	if errors.is_empty():
		_error_lbl.hide()
		return true
	else:
		_error_lbl.text = "\n".join(errors)
		_error_lbl.show()
		return false

func _is_valid_email(email: String) -> bool:
	var at_pos = email.find("@")
	if at_pos < 1:
		return false
	var dot_pos = email.rfind(".")
	return dot_pos > at_pos + 1 and dot_pos < email.length() - 1
