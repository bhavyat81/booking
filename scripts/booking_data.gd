extends Resource
class_name BookingData

# Route constants
const ROUTE_WINDSOR_TO_TORONTO = "Windsor → Toronto"
const ROUTE_TORONTO_TO_WINDSOR = "Toronto → Windsor"
const DEPARTURE_WINDSOR = "5:00 AM"
const DEPARTURE_TORONTO = "3:00 PM"

# Booking details
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
	# Generate a random 8-character booking reference
	var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	var ref = "WTR-"
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(6):
		ref += chars[rng.randi() % chars.length()]
	booking_reference = ref
	return ref

func to_dict() -> Dictionary:
	return {
		"route": route,
		"departure_time": departure_time,
		"name": name,
		"phone": phone,
		"email": email,
		"num_bags": num_bags,
		"pickup_address": pickup_address,
		"dropoff_address": dropoff_address,
		"date": date,
		"booking_reference": booking_reference
	}
