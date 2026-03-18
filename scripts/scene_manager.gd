extends Node
# SceneManager: Autoload singleton for scene transitions

const SCENE_CALENDAR     = "res://scenes/calendar/calendar.tscn"
const SCENE_HOME         = "res://scenes/calendar/calendar.tscn"  # alias
const SCENE_BOOKING_FORM = "res://scenes/booking_form/booking_form.tscn"
const SCENE_CONFIRMATION = "res://scenes/confirmation/confirmation.tscn"

# Current booking data shared between scenes
var current_booking: BookingData = null

func go_to_calendar() -> void:
	current_booking = null
	get_tree().change_scene_to_file(SCENE_CALENDAR)

func go_home() -> void:
	go_to_calendar()

func go_to_booking_form(booking: BookingData) -> void:
	current_booking = booking
	get_tree().change_scene_to_file(SCENE_BOOKING_FORM)

func go_to_confirmation(booking: BookingData) -> void:
	current_booking = booking
	get_tree().change_scene_to_file(SCENE_CONFIRMATION)
