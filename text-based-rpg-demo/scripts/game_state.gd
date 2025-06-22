extends Node

var active_color = Color.WEB_GREEN

var lines_created: int = 0: # TO KEEP TRACK OF PLAYER SPENT TIME // USE EXAGGARATED NUMBERS
	set(value):
		if lines_created % 10 == 0:
			print("Game State: lines_created = " + str(value))
		lines_created = value
	get:
		return(lines_created)


var never_see_line = false

# --------------------------------------NANCE
var has_met_nance: bool = false
var nance_flirted: int = 0
var nance_lines_created: int = 0

func romanced_nance(amount):
	nance_flirted += amount
	print_debug("flirted nance: " + str(amount))

func update_nance_lines(number):
	nance_lines_created = number
	print_debug("nance_lines_created= " + str(nance_lines_created))
	print_debug("lines_created= " + str(lines_created))


# --------------------------------------CASEY
<<<<<<< Updated upstream
var casey_relation: int= 0


func casey_relationship(casey_number):
	casey_relation += casey_number
	print_debug("Casey relation: " + str(casey_number))
=======
var has_met_casey: bool = false

var casey_relation: int= 0:
	set(casey_number):
		casey_relation = casey_number
		print_debug("Casey_relation: " + str(casey_relation))

var casey_prog: int= 0:
	set(progress_number):
		casey_prog = progress_number
		print_debug("Casey_prog: " + str(casey_prog))

var casey_story_told = 0:
	set(value):
		print_debug("casey_story_told: " + str(value))



# --------------------------------------CHROME
var has_met_chrome: bool = false




func check_bool(variable, number) -> bool:
	if variable == number:
		print_debug("check_bool: true") 
		return true
	else:
		print_debug("check_bool: false")
		return false


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
>>>>>>> Stashed changes
