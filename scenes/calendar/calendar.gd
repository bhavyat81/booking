extends Control
# Calendar Screen — premium date picker, main/home scene

# ── Colour palette ───────────────────────────────────────────────────────────
const C_BG       = Color(0.0588, 0.0588, 0.102)   # #0F0F1A
const C_CARD     = Color(0.102,  0.102,  0.180)   # #1A1A2E
const C_ACCENT   = Color(0.914,  0.271,  0.376)   # #E94560
const C_GOLD     = Color(1.0,    0.843,  0.0)     # #FFD700
const C_TEXT     = Color(1.0,    1.0,    1.0)     # #FFFFFF
const C_TEXT_SEC = Color(0.533,  0.533,  0.667)   # #8888AA

const MONTH_NAMES = [
	"January", "February", "March", "April", "May", "June",
	"July", "August", "September", "October", "November", "December"
]
const DAYS_IN_MONTH = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

var _current_month: int
var _current_year: int
var _selected_day: int   = -1
var _selected_month: int = -1
var _selected_year: int  = -1

@onready var _bg:           ColorRect    = $Background
@onready var _main_vbox:    VBoxContainer = $MainVBox
@onready var _header:       VBoxContainer = $MainVBox/Header
@onready var _title_lbl:    Label        = $MainVBox/Header/TitleLabel
@onready var _tagline_lbl:  Label        = $MainVBox/Header/TaglineLabel
@onready var _month_nav:    HBoxContainer = $MainVBox/MonthNav
@onready var _prev_btn:     Button       = $MainVBox/MonthNav/PrevMonthBtn
@onready var _month_lbl:    Label        = $MainVBox/MonthNav/MonthYearLabel
@onready var _next_btn:     Button       = $MainVBox/MonthNav/NextMonthBtn
@onready var _day_headers:  GridContainer = $MainVBox/DayHeaders
@onready var _calendar_grid: GridContainer = $MainVBox/CalendarGrid
@onready var _sel_date_lbl: Label        = $MainVBox/SelectedDateLabel
@onready var _continue_btn: Button       = $MainVBox/ContinueBtn

func _ready() -> void:
	_apply_styles()
	var now = Time.get_datetime_dict_from_system()
	_current_month = now["month"]
	_current_year  = now["year"]
	_rebuild_calendar()

# ── Styling ──────────────────────────────────────────────────────────────────

func _apply_styles() -> void:
	_bg.color = C_BG

	# Main VBox padding
	_main_vbox.add_theme_constant_override("separation", 0)

	# Header section
	_header.add_theme_constant_override("separation", 4)
	# Title
	_title_lbl.add_theme_font_size_override("font_size", 30)
	_title_lbl.add_theme_color_override("font_color", C_ACCENT)

	# Tagline
	_tagline_lbl.add_theme_font_size_override("font_size", 15)
	_tagline_lbl.add_theme_color_override("font_color", C_GOLD)

	# Month nav
	_month_nav.add_theme_constant_override("separation", 0)
	_style_nav_btn(_prev_btn)
	_style_nav_btn(_next_btn)

	_month_lbl.add_theme_font_size_override("font_size", 20)
	_month_lbl.add_theme_color_override("font_color", C_TEXT)
	_month_lbl.custom_minimum_size = Vector2(200, 44)
	_month_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	# Day header row
	_day_headers.add_theme_constant_override("h_separation", 0)
	_day_headers.add_theme_constant_override("v_separation", 0)
	for child in _day_headers.get_children():
		if child is Label:
			child.add_theme_font_size_override("font_size", 13)
			child.add_theme_color_override("font_color", C_TEXT_SEC)
			child.custom_minimum_size = Vector2(50, 32)
			child.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	# Calendar grid
	_calendar_grid.add_theme_constant_override("h_separation", 2)
	_calendar_grid.add_theme_constant_override("v_separation", 2)

	# Selected date label
	_sel_date_lbl.add_theme_font_size_override("font_size", 17)
	_sel_date_lbl.add_theme_color_override("font_color", C_TEXT_SEC)

	# Continue button
	_continue_btn.custom_minimum_size = Vector2(0, 56)
	_continue_btn.disabled = true
	_style_accent_btn(_continue_btn)
	_continue_btn.add_theme_font_size_override("font_size", 20)

func _style_nav_btn(btn: Button) -> void:
	btn.custom_minimum_size = Vector2(50, 44)
	btn.add_theme_font_size_override("font_size", 26)
	var s = StyleBoxFlat.new()
	s.bg_color = C_CARD
	s.set_content_margin_all(8.0)
	btn.add_theme_stylebox_override("normal",   s)
	btn.add_theme_stylebox_override("hover",    s)
	btn.add_theme_stylebox_override("pressed",  s)
	btn.add_theme_stylebox_override("focus",    StyleBoxEmpty.new())
	btn.add_theme_color_override("font_color", C_GOLD)

func _style_accent_btn(btn: Button) -> void:
	var s_normal = StyleBoxFlat.new()
	s_normal.bg_color = C_ACCENT
	s_normal.corner_radius_top_left    = 14
	s_normal.corner_radius_top_right   = 14
	s_normal.corner_radius_bottom_right = 14
	s_normal.corner_radius_bottom_left  = 14
	s_normal.set_content_margin_all(14.0)
	var s_disabled = StyleBoxFlat.new()
	s_disabled.bg_color = Color(0.3, 0.3, 0.4)
	s_disabled.corner_radius_top_left    = 14
	s_disabled.corner_radius_top_right   = 14
	s_disabled.corner_radius_bottom_right = 14
	s_disabled.corner_radius_bottom_left  = 14
	s_disabled.set_content_margin_all(14.0)
	btn.add_theme_stylebox_override("normal",   s_normal)
	btn.add_theme_stylebox_override("hover",    s_normal)
	btn.add_theme_stylebox_override("pressed",  s_normal)
	btn.add_theme_stylebox_override("disabled", s_disabled)
	btn.add_theme_stylebox_override("focus",    StyleBoxEmpty.new())
	btn.add_theme_color_override("font_color",          C_TEXT)
	btn.add_theme_color_override("font_hover_color",    C_TEXT)
	btn.add_theme_color_override("font_pressed_color",  C_TEXT)
	btn.add_theme_color_override("font_disabled_color", C_TEXT_SEC)

# ── Calendar Logic ────────────────────────────────────────────────────────────

func _get_days_in_month(month: int, year: int) -> int:
	if month == 2:
		var leap = (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)
		return 29 if leap else 28
	return DAYS_IN_MONTH[month - 1]

func _day_of_week(day: int, month: int, year: int) -> int:
	# Tomohiko Sakamoto — returns 0=Sun … 6=Sat
	var t = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4]
	var y = year
	if month < 3:
		y -= 1
	return (y + y / 4 - y / 100 + y / 400 + t[month - 1] + day) % 7

func _rebuild_calendar() -> void:
	# Remove old day cells immediately
	for child in _calendar_grid.get_children():
		_calendar_grid.remove_child(child)
		child.queue_free()

	_month_lbl.text = MONTH_NAMES[_current_month - 1] + "  " + str(_current_year)

	var days_in_month = _get_days_in_month(_current_month, _current_year)
	var first_weekday = _day_of_week(1, _current_month, _current_year)

	# Empty placeholder cells before day 1
	for _i in range(first_weekday):
		var spacer = Control.new()
		spacer.custom_minimum_size = Vector2(50, 46)
		_calendar_grid.add_child(spacer)

	# Day buttons
	for day in range(1, days_in_month + 1):
		var btn = Button.new()
		btn.text = str(day)
		btn.custom_minimum_size = Vector2(50, 46)
		btn.flat = true
		var is_selected = (day == _selected_day and
				_current_month == _selected_month and
				_current_year  == _selected_year)
		_style_day_btn(btn, is_selected)
		btn.pressed.connect(_on_day_pressed.bind(day))
		_calendar_grid.add_child(btn)

func _style_day_btn(btn: Button, selected: bool) -> void:
	var s = StyleBoxFlat.new()
	s.corner_radius_top_left    = 23
	s.corner_radius_top_right   = 23
	s.corner_radius_bottom_right = 23
	s.corner_radius_bottom_left  = 23
	s.set_content_margin_all(4.0)
	if selected:
		s.bg_color = C_ACCENT
		btn.add_theme_color_override("font_color",         C_TEXT)
		btn.add_theme_color_override("font_hover_color",   C_TEXT)
		btn.add_theme_color_override("font_pressed_color", C_TEXT)
	else:
		s.bg_color = Color(0, 0, 0, 0)
		btn.add_theme_color_override("font_color",         C_TEXT)
		btn.add_theme_color_override("font_hover_color",   C_ACCENT)
		btn.add_theme_color_override("font_pressed_color", C_ACCENT)
	btn.add_theme_stylebox_override("normal",  s)
	btn.add_theme_stylebox_override("hover",   s)
	btn.add_theme_stylebox_override("pressed", s)
	btn.add_theme_stylebox_override("focus",   StyleBoxEmpty.new())
	btn.add_theme_font_size_override("font_size", 16)

# ── Signals ───────────────────────────────────────────────────────────────────

func _on_day_pressed(day: int) -> void:
	_selected_day   = day
	_selected_month = _current_month
	_selected_year  = _current_year
	_rebuild_calendar()
	var date_str = MONTH_NAMES[_selected_month - 1] + " " + str(_selected_day) + ", " + str(_selected_year)
	_sel_date_lbl.text = date_str
	_sel_date_lbl.add_theme_color_override("font_color", C_GOLD)
	_continue_btn.disabled = false

func _on_prev_month_pressed() -> void:
	_current_month -= 1
	if _current_month < 1:
		_current_month = 12
		_current_year -= 1
	_rebuild_calendar()

func _on_next_month_pressed() -> void:
	_current_month += 1
	if _current_month > 12:
		_current_month = 1
		_current_year += 1
	_rebuild_calendar()

func _on_continue_pressed() -> void:
	if _selected_day == -1:
		return
	var date_str = MONTH_NAMES[_selected_month - 1] + " " + str(_selected_day) + ", " + str(_selected_year)
	var booking = BookingData.new()
	booking.selected_date = date_str
	SceneManager.go_to_booking_form(booking)
