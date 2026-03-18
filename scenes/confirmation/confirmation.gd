extends Control
# Confirmation Screen -- premium booking success view

# -- Colour palette ----------------------------------------------------------
const C_BG       = Color(0.0588, 0.0588, 0.102)  # #0F0F1A
const C_CARD     = Color(0.102,  0.102,  0.180)  # #1A1A2E
const C_ACCENT   = Color(0.914,  0.271,  0.376)  # #E94560
const C_GOLD     = Color(1.0,    0.843,  0.0)    # #FFD700
const C_TEXT     = Color(1.0,    1.0,    1.0)    # #FFFFFF
const C_TEXT_SEC = Color(0.533,  0.533,  0.667)  # #8888AA
const C_SUCCESS  = Color(0.0,    0.784,  0.325)  # #00C853

@onready var _bg:            ColorRect      = $Background
@onready var _content_vbox:  VBoxContainer  = $ScrollContainer/ContentVBox
@onready var _success_icon:  Label          = $ScrollContainer/ContentVBox/SuccessIcon
@onready var _success_title: Label          = $ScrollContainer/ContentVBox/SuccessTitle
@onready var _ref_label:     Label          = $ScrollContainer/ContentVBox/RefLabel
@onready var _summary_card:  VBoxContainer  = $ScrollContainer/ContentVBox/SummaryCard
@onready var _email_lbl:     Label          = $ScrollContainer/ContentVBox/EmailSentLabel
@onready var _book_another:  Button         = $ScrollContainer/ContentVBox/BookAnotherBtn

func _ready() -> void:
	var booking = SceneManager.current_booking
	if booking == null:
		SceneManager.go_to_calendar()
		return
	_apply_styles()
	_populate(booking)

# -- Styling ------------------------------------------------------------------

func _apply_styles() -> void:
	_bg.color = C_BG
	_content_vbox.add_theme_constant_override("separation", 14)

	# Success icon
	_success_icon.add_theme_font_size_override("font_size", 64)

	# Success title
	_success_title.add_theme_font_size_override("font_size", 26)
	_success_title.add_theme_color_override("font_color", C_SUCCESS)

	# Reference label
	_ref_label.add_theme_font_size_override("font_size", 20)
	_ref_label.add_theme_color_override("font_color", C_GOLD)

	# Email sent label
	_email_lbl.add_theme_font_size_override("font_size", 14)
	_email_lbl.add_theme_color_override("font_color", C_SUCCESS)

	# Book Another button
	var s = StyleBoxFlat.new()
	s.bg_color = C_ACCENT
	s.corner_radius_top_left     = 14
	s.corner_radius_top_right    = 14
	s.corner_radius_bottom_right = 14
	s.corner_radius_bottom_left  = 14
	s.set_content_margin_all(14.0)
	_book_another.add_theme_stylebox_override("normal",  s)
	_book_another.add_theme_stylebox_override("hover",   s)
	_book_another.add_theme_stylebox_override("pressed", s)
	_book_another.add_theme_stylebox_override("focus",   StyleBoxEmpty.new())
	_book_another.add_theme_color_override("font_color",         C_TEXT)
	_book_another.add_theme_color_override("font_hover_color",   C_TEXT)
	_book_another.add_theme_color_override("font_pressed_color", C_TEXT)
	_book_another.add_theme_font_size_override("font_size", 18)

# -- Data population ----------------------------------------------------------

func _populate(booking: BookingData) -> void:
	_success_icon.text = "\u2705"
	_ref_label.text = booking.booking_reference

	# Build summary card
	var card_style = StyleBoxFlat.new()
	card_style.bg_color = C_CARD
	card_style.corner_radius_top_left     = 14
	card_style.corner_radius_top_right    = 14
	card_style.corner_radius_bottom_right = 14
	card_style.corner_radius_bottom_left  = 14
	card_style.set_content_margin_all(16.0)

	var card_panel = PanelContainer.new()
	card_panel.add_theme_stylebox_override("panel", card_style)
	var card_vbox = VBoxContainer.new()
	card_vbox.add_theme_constant_override("separation", 10)
	card_panel.add_child(card_vbox)

	var rows = [
		["Date",      booking.selected_date],
		["Route",     booking.route],
		["Departure", booking.departure_time],
		["Name",      booking.name],
		["Phone",     booking.phone],
		["Email",     booking.email],
		["Bags",      str(booking.num_bags)],
		["Pickup",    booking.pickup_address],
		["Drop-off",  booking.dropoff_address],
	]

	for row in rows:
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 8)

		var key_lbl = Label.new()
		key_lbl.text = row[0] + ":"
		key_lbl.custom_minimum_size = Vector2(90, 0)
		key_lbl.add_theme_font_size_override("font_size", 14)
		key_lbl.add_theme_color_override("font_color", C_TEXT_SEC)

		var val_lbl = Label.new()
		val_lbl.text = row[1]
		val_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		val_lbl.add_theme_font_size_override("font_size", 14)
		val_lbl.add_theme_color_override("font_color", C_TEXT)
		val_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD

		hbox.add_child(key_lbl)
		hbox.add_child(val_lbl)
		card_vbox.add_child(hbox)

	_summary_card.add_child(card_panel)

# -- Signals ------------------------------------------------------------------

func _on_book_another_pressed() -> void:
	SceneManager.go_to_calendar()
