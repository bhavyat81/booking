extends Node
# SceneManager: Autoload singleton for scene transitions

const SCENE_HOME = "res://scenes/home/home.tscn"
const SCENE_BOOKING_FORM = "res://scenes/booking_form/booking_form.tscn"
const SCENE_CONFIRMATION = "res://scenes/confirmation/confirmation.tscn"

# Current booking data shared between scenes
var current_booking: BookingData = null

func go_home() -> void:
	current_booking = null
	get_tree().change_scene_to_file(SCENE_HOME)

func go_to_booking_form(booking: BookingData) -> void:
	current_booking = booking
	get_tree().change_scene_to_file(SCENE_BOOKING_FORM)

func go_to_confirmation(booking: BookingData) -> void:
	current_booking = booking
	get_tree().change_scene_to_file(SCENE_CONFIRMATION)
