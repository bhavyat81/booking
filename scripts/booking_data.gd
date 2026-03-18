extends Resource
class_name BookingData

# Route constants — 3 daily rides
const ROUTE_WINDSOR_TO_TORONTO = "Windsor \u2192 Toronto"
const ROUTE_TORONTO_TO_WINDSOR = "Toronto \u2192 Windsor"
const DEPARTURE_5AM   = "5:00 AM"
const DEPARTURE_930AM = "9:30 AM"
const DEPARTURE_3PM   = "3:00 PM"

# Legacy aliases kept for backwards compatibility
const DEPARTURE_WINDSOR = DEPARTURE_5AM
const DEPARTURE_TORONTO = DEPARTURE_3PM

# Route list: [emoji, departure_time, route_label]
const ROUTES = [
	["🌅", "5:00 AM",  "Windsor \u2192 Toronto"],
	["🌄", "9:30 AM",  "Toronto \u2192 Windsor"],
	["🌇", "3:00 PM",  "Windsor \u2192 Toronto"],
]

# Booking details
var selected_date: String = ""
var route: String = ""
var departure_time: String = ""
var name: String = ""
var phone: String = ""
var email: String = ""
var num_bags: int = 0
var pickup_address: String = ""
var dropoff_address: String = ""
var date: String = ""
var booking_reference: String = ""

func generate_reference() -> String:
	var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	var ref = "JRS-"
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(6):
		ref += chars[rng.randi() % chars.length()]
	booking_reference = ref
	return ref

func to_dict() -> Dictionary:
	return {
		"booking_reference": booking_reference,
		"selected_date": selected_date,
		"route": route,
		"departure_time": departure_time,
		"name": name,
		"phone": phone,
		"email": email,
		"num_bags": num_bags,
		"pickup_address": pickup_address,
		"dropoff_address": dropoff_address,
	}
