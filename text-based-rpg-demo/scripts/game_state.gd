extends Node

var debug_mode: bool = true

func _ready() -> void:
	if debug_mode == true:
		dictionary_frequency_given = true
		plugin_bitmap_installed = true
		plugin_audio_installed = true

# -------------------------------------- GAME VARIABLES
var lines_created: int = 0: # TO KEEP TRACK OF PLAYER SPENT TIME // USE EXAGGARATED NUMBERS
	set(value):
		if lines_created % 10 == 0:
			print("Game State: lines_created = " + str(value))
		lines_created = value
	get:
		return(lines_created)

var never_see_line = false
var connected_number: int = 0
var all_chats: Array = ["Nance", "CASEY", "chrome", "FreeDictionary", "dead_channel"]


# -------------------------------------- PLAYER VARIABLES
var active_color = Color.WEB_GREEN
var player_name: String


# --------------------------------------NANCE
var has_met_nance: bool = false

var nance_flirted: int = 0:
	set(amount):
		print_debug("flirted Nance: " + str(amount))

var nance_prog: int= 0:
	set(progress_number):
		nance_prog += progress_number
		print_debug("Nance progress: " + str(nance_prog))
	get:
		print_debug("Nance progress: " + str(nance_prog))
		return nance_prog

var nance_lines_created: int = 0:
	set(number):
		nance_lines_created = number
		print_debug("nance_lines_created= " + str(nance_lines_created))
		print_debug("lines_created= " + str(lines_created))

var player_in_syndicate: int = 0



# --------------------------------------CASEY
var has_met_casey: bool = false

var casey_relation: int= 0:
	set(casey_number):
		casey_relation += casey_number
		print_debug("CASEY relation: " + str(casey_relation))

var casey_prog: int= 0:
	set(progress_number):
		casey_prog += progress_number
		print_debug("CASEY progress: " + str(casey_prog))
	get:
		print_debug("Casey progress: " + str(casey_prog))
		return casey_prog

var casey_story_told = 0:
	set(value):
		print_debug("casey_story_told: " + str(value))


var casey_knows_syndicate: int = 0 # 0 Syndicate not spoken 1 Casey thinks Player is out 2 Casey knows Player is in 

var dictionary_frequency_given: bool = false


# --------------------------------------chrome
var has_met_chrome: bool = false

var chrome_relation: int= 0:
	set(casey_number):
		casey_relation += casey_number
		print_debug("Casey relation: " + str(casey_number))

var chrome_lines: int = 0

var plugin_bitmap_installed: int = 0 #0 for unknown 1 for known but isn't activated 2 for active
var plugin_audio_installed: int = 0 #0 for unknown 1 for known but isn't activated 2 for active








#func casey_relationship(casey_number):
	#casey_relation += casey_number
	#print_debug("Casey relation: " + str(casey_number))

#func casey_progress(progress_number):
	#casey_prog += progress_number
	#print_debug("Casey relation: " + str(progress_number))

#func romanced_nance(amount):
	#nance_flirted += amount
	#print_debug("flirted nance: " + str(amount))

#func update_nance_lines(number):
	#nance_lines_created = number
	#print_debug("nance_lines_created= " + str(nance_lines_created))
	#print_debug("lines_created= " + str(lines_created))
