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
var casey_relation: int= 0


func casey_relationship(casey_number):
	casey_relation += casey_number
	print_debug("Casey relation: " + str(casey_number))
