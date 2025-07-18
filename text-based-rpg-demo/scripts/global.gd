extends Node

signal resolution_changed

const GAME = preload("res://scenes/game.tscn")

var font_theme: Theme = load("res://themes/green_font.tres")
var input_font_theme: Theme = load("res://themes/input_color_trial.tres")

var computer_has_booted := false

var resolution:= Vector2(720,480)
var is_fullscreen:= false
var font_size:= 16
var audio_level:= 1.0
var font_color:= "green"

var active_tab #checked by game.gd - first declared by tab_container.gd

var blue:= Color(0.0, 0.51, 1.0)
var green:= Color(0.275, 0.707, 0.101)
var red:= Color(0.863, 0.078, 0.235)
var yellow:= Color(0.949, 0.949, 0.0)
var active_color: Color = Color(0.275, 0.707, 0.101)

var config = ConfigFile.new()

@onready var canvas_layer: CanvasLayer = get_parent().get_child(3)
@onready var tab_container: TabContainer = canvas_layer.get_child(1)

func _ready() -> void:
	tab_container.set_theme(font_theme)
	change_resolution(Vector2(DisplayServer.screen_get_size().x - 200, DisplayServer.screen_get_size().y - 200))
	load_from_file()
	font_theme = load("res://themes/" + font_color + "_font.tres")
	change_resolution(resolution)
	if is_fullscreen == true:
		set_fullscreen("fullscreen")
	elif is_fullscreen == false:
		set_fullscreen("windowed")
	change_font_size(font_size)
	change_audio(audio_level)
	
	print("font size= ", font_size)



func save_to_file():
	pass
	#config.set_value("preferences", "resolution", resolution)
	#config.set_value("preferences", "is_fullscreen", is_fullscreen)
	#config.set_value("preferences", "font_size", font_size)
	#config.set_value("preferences", "audio_level", audio_level)
	#config.set_value("preferences", "font_color", font_color)
	#config.save("user://preferences.cfg")

func load_from_file():
	pass
	#var err= config.load("user://preferences.cfg")
	#if err == OK:
		#resolution= config.get_value("preferences", "resolution")
		#is_fullscreen= config.get_value("preferences", "is_fullscreen")
		#font_size= config.get_value("preferences", "font_size")
		#audio_level= config.get_value("preferences", "audio_level")
		#font_color= config.get_value("preferences", "font_color")




func change_resolution(target_res: Vector2):
	DisplayServer.window_set_size(target_res)
	@warning_ignore("narrowing_conversion")
	change_font_size(target_res.y / 28)
	DisplayServer.window_set_position(Vector2(0,0))
	resolution_changed.emit()
	resolution = target_res
	save_to_file()



func change_font_size(size: int):
	font_theme.set_default_font_size(size)
	
	input_font_theme.set_default_font_size(size)
	
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


func booted():
	get_current_chat().get_child(1)._on_game_booted()


func get_sound_player(which):
	return get_current_chat().get_child(1).get_child(which) as AudioStreamPlayer


func change_chat(chat_dialogue_res: String) -> void:
	GameState.connected_number += 1
	get_sound_player(2).stream = load("res://sounds/yükselen_ince_ses_lowered_more(mp3cut.net).wav")
	get_sound_player(2).play()
	await get_tree().create_timer(1).timeout
	# CONNECTING EFFECT
	
	var new_chat = GAME.instantiate()
	new_chat.name = chat_dialogue_res
	new_chat.dialogue = load("res://Dialogues/" + chat_dialogue_res + ".dialogue")
	tab_container.add_child(new_chat) #LOADING DIALOGUE FIRST RUNS [DO] LINES FOR THE PREVIOUS CHAT; FOR FIRST LINE
	tab_container.current_tab = tab_container.get_tab_count() -1
	# ADDING THE CHAT
	
	for chat in GameState.all_available_chats:
		if chat == chat_dialogue_res:
			GameState.all_available_chats.erase(chat)
			print_debug("available chats: " + str(GameState.all_available_chats))


func change_chat_random() -> void:
	pass
	var random_chat_number = randi_range(0, GameState.all_available_chats.size() - 1)
	var random_chat = GameState.all_available_chats[random_chat_number]
	print_debug("random_chat: " + str(random_chat))
	
	change_chat(random_chat)


func change_interface_color(color):
	font_theme = load("res://themes/" + color + "_font.tres")
	font_color = color
	update_current_system_color()
	tab_container.set_theme(font_theme)
	change_font_size(font_size)
	change_input_color(active_color)

func change_input_color(incoming_color):
	input_font_theme.set_color("font_color", "Label", incoming_color)
	
	input_font_theme.set_color("font_color", "LineEdit", incoming_color)
	input_font_theme.set_color("caret_color", "LineEdit", incoming_color)
	
	input_font_theme.set_color("default_color", "Preview", Color(incoming_color.r, incoming_color.b, incoming_color.g, incoming_color.a * 0.5))


func update_current_system_color():
	if font_color == "blue":
		active_color = blue
	if font_color == "green":
		active_color = green
	if font_color == "red":
		active_color = red
	if font_color == "yellow":
		active_color = yellow


func get_current_chat():
	var current_chat = tab_container.get_child(tab_container.current_tab)
	return current_chat


func get_chat_named(specific_name: String):
	return tab_container.get_node(specific_name)



func create_empty_lines(chat_name: String,should: bool):
	tab_container.get_node(chat_name).should_create_empty_lines = should


func set_line_editable(chat_name: String, is_editable: bool):
	tab_container.get_node(chat_name).line_edit.editable = is_editable


func tab_is_offline(this_chat: String, offline: bool):
	var node = tab_container.get_node(this_chat)
	var which_chat = node.get_index(false)
	tab_container.set_tab_disabled(which_chat, offline)


func returning_message(returning_chat: String):
	var game_node = tab_container.get_node(returning_chat)
	game_node.typing_sound_manager.notification_sound()
	game_node._on_line_edit_text_submitted("")


func spesific_message(chat_id: String , message: String):
	if message == "":
		await get_tree().create_timer(0.2).timeout
	else:
		pass
	get_chat_named(chat_id)._on_line_edit_text_submitted(message)



func go_to_this_line(desired_chat: String, id: String):
	var tab = get_chat_named(desired_chat)
	var input_resp = tab.history_rows.get_child(tab.history_rows.get_child_count() - 3)
	var refreshed_line = await DialogueManager.get_next_dialogue_line(tab.dialogue, id)
	input_resp.response.dialogue_line = refreshed_line
	input_resp.response.skip_typing()  # or skip_typing()

	tab.dialogue_line = refreshed_line

	# Use the same allowed-response filtering as in your submit function
	var bits := []
	for resp in refreshed_line.responses:
		if not resp.is_allowed:
			continue
		bits.append(resp.text)
	tab.line_edit.create_placeholder_text(0, " / ".join(bits))




#var one_time: bool = false
var offline_chats: Array
func check_created_line(chat_name: String, number_needed: int):
	if not offline_chats.has(chat_name):
	#if one_time == false:
		offline_chats.append(chat_name)
		#one_time = true
		while number_needed > GameState.lines_created:
			print(chat_name, " is offline")
			await get_tree().create_timer(3).timeout
		
		print(chat_name, " is online")
		match chat_name:
			"Nance":
				GameState.nance_offline = false
			"CASEY":
				GameState.casey_offline = false
			"chrome":
				GameState.chrome_offline = false
		returning_message(chat_name)
		offline_chats.erase(chat_name)
		return
	else:
		return



func play_music():
	#SINCE THERE IS ONE MUSIC RN, NOT USING THE PARAMETER
	get_chat_named("Nance").typing_sound_manager.play_music()


func dialogue_print(to_print):
	print("Global.gd: " + str(to_print))
