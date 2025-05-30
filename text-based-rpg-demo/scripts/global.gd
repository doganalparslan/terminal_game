extends Node

signal resolution_changed

const GAME = preload("res://scenes/game.tscn")

var font_theme: Theme = load("res://themes/green_font.tres")

var computer_has_booted := false

var resolution:= Vector2(720,480)
var is_fullscreen:= false
var font_size:= 16
var audio_level:= 1.0
var font_color:= "green"

var blue:= Color(0.0, 0.51, 1.0)
var green:= Color(0.275, 0.707, 0.101)
var red:= Color(0.863, 0.078, 0.235)
var yellow:= Color(0.949, 0.949, 0.0)
var active_color: Color = green

var config = ConfigFile.new()

@onready var canvas_layer: CanvasLayer = get_parent().get_child(3)
@onready var tab_container: TabContainer = canvas_layer.get_child(1)

func _ready() -> void:
	tab_container.set_theme(font_theme)
	change_resolution(DisplayServer.window_get_size())
	load_from_file()
	font_theme = load("res://themes/" + font_color + "_font.tres")
	change_resolution(resolution)
	if is_fullscreen == true:
		set_fullscreen("fullscreen")
	elif is_fullscreen == false:
		set_fullscreen("windowed")
	change_font_size(font_size)
	change_audio(audio_level)



func save_to_file():
	config.set_value("preferences", "resolution", resolution)
	config.set_value("preferences", "is_fullscreen", is_fullscreen)
	config.set_value("preferences", "font_size", font_size)
	config.set_value("preferences", "audio_level", audio_level)
	config.set_value("preferences", "font_color", font_color)
	config.save("user://preferences.cfg")

func load_from_file():
	var err= config.load("user://preferences.cfg")
	if err == OK:
		resolution= config.get_value("preferences", "resolution")
		is_fullscreen= config.get_value("preferences", "is_fullscreen")
		font_size= config.get_value("preferences", "font_size")
		audio_level= config.get_value("preferences", "audio_level")
		font_color= config.get_value("preferences", "font_color")




func change_resolution(target_res: Vector2):
	DisplayServer.window_set_size(target_res)
	change_font_size(target_res.y / 28)
	DisplayServer.window_set_position(Vector2(0,0))
	resolution_changed.emit()
	resolution = target_res
	save_to_file()



func change_font_size(size: int):
	font_theme.set_default_font_size(size)
	font_size = size
	save_to_file()



func set_fullscreen(screen_mode):
	match screen_mode:
		"windowed":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			Global.change_resolution(DisplayServer.window_get_size())
			is_fullscreen = false
			save_to_file()
		"fullscreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Global.change_resolution(DisplayServer.window_get_size())
			is_fullscreen = true
			save_to_file()



func change_audio(audio: float):
	AudioServer.set_bus_volume_linear(0, audio)
	audio_level = audio
	save_to_file()



func change_chat(chat_dialogue_res: String):
	var new_chat = GAME.instantiate()
	new_chat.name = chat_dialogue_res
	new_chat.dialogue = load("res://Dialogues/" + chat_dialogue_res + ".dialogue")
	tab_container.add_child(new_chat) #LOADING DIALOGUE FIRST RUNS [DO] LINES FOR THE PREVIOUS CHAT; FOR FIRST LINE
	tab_container.current_tab = tab_container.get_tab_count() -1
	new_chat.line_edit.grab_focus()



func change_interface_color(color):
	font_theme = load("res://themes/" + color + "_font.tres")
	font_color = color
	update_current_system_color()
	tab_container.set_theme(font_theme)
	change_font_size(font_size)



func get_current_chat():
	var current_chat = tab_container.get_child(tab_container.current_tab)
	return current_chat



func create_empty_lines(should: bool):
	get_current_chat().should_create_empty_lines = should



func set_line_editable(is_editable: bool):
	print_debug(tab_container.current_tab)
	print_debug(get_current_chat())
	get_current_chat().line_edit.editable = is_editable


func update_current_system_color():
	if font_color == "blue":
		active_color = blue
	if font_color == "green":
		active_color = green
	if font_color == "red":
		active_color = red
	if font_color == "yellow":
		active_color = yellow
