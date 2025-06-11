extends Control

signal enter_pressed

const INPUTRESPONSE = preload("res://scenes/input_response.tscn")

var dialogue = preload("res://Dialogues/Computer.dialogue")

var should_create_empty_lines = true
var prompt_line = ""
var option_proceed:= true
var line_is_skipped = false
var line_done = false
var bits := []
var response_line

@onready var dialogue_line = await dialogue.get_next_dialogue_line()

@export var max_lines_remembered: int = 100

@onready var history_rows: VBoxContainer = $Background/MarginContainer/Rows/GameInfo/Scroll/MarginContainer/HistoryRows
@onready var line_edit: LineEdit = $Background/MarginContainer/Rows/GameInfo/Scroll/MarginContainer/HistoryRows/LineEdit

@onready var command_processor: Node = $CommandProcessor

var second = 0

func _ready() -> void:
	if dialogue == load("res://Dialogues/Computer.dialogue"):
		get_child(1)._on_game_booted()
		await get_tree().create_timer(4.5).timeout
	_on_line_edit_text_submitted("")
	line_edit.grab_focus()



func _on_line_edit_text_submitted(new_text: String) -> void:
	enter_pressed.emit()
	var answer := new_text.strip_edges().to_lower()

	GameState.lines_created += 1

	var input_response: VBoxContainer = INPUTRESPONSE.instantiate()
	history_rows.add_child(input_response) #writes the text to screen using input_response scene
	input_response.set_input_text(new_text)
	
	if option_proceed == true:
		input_response.response.connect("spoke", $TypingSoundManager.on_npc_typed_one_character) # for playing beep sounds
		connect("enter_pressed", input_response.enter_pressed) #for handling skip inside the input_response.gd
		input_response.connect("line_skipped", self.line_skipped)
		input_response.connect("next_auto", self.next_auto)
		input_response.response.connect("finished_typing", self.finished_typing)

		if should_create_empty_lines == true:
			input_response.create_empty_lines()

		input_response.response.dialogue_line = dialogue_line
		input_response.response.type_out()
		line_is_skipped = false
		line_done = false
	
	if dialogue_line.responses.size() > 0:
		response_line = dialogue_line
		for resp in dialogue_line.responses:
			if not resp.is_allowed: # looks for the responses that are unabled
				continue
			bits.append(resp.text)
			var option : String = resp.text.strip_edges().to_lower()
			if answer == option:
				option_proceed = true
				input_response.input_history.text = new_text
				var chosen_id = resp.next_id
				dialogue_line = await DialogueManager.get_next_dialogue_line(dialogue, chosen_id)
				prompt_line = ""
				bits = []
				line_edit.create_placeholder_text(0, "")
				line_edit_to_end()
				if dialogue == load("res://Dialogues/Computer.dialogue"):
					pass
				else:
					await get_tree().create_timer(randf_range(0.3, 1)).timeout
				_on_line_edit_text_submitted("")
				return
			else:
				option_proceed = false
				if new_text != "":
					input_response.input_history.text = ""
				
		
	
	else:
		input_response.input_history.queue_free()
		line_edit.create_placeholder_text(0, "")
		dialogue_line = await DialogueManager.get_next_dialogue_line(dialogue, dialogue_line.next_id)
	
	
	
	line_edit_to_end()
	line_edit.grab_focus()



func finished_typing(_dialogue_label):
	line_edit.create_placeholder_text(0, "")
	if _dialogue_label.dialogue_line == response_line:
		prompt_line = " / ".join(bits)
		line_edit.create_placeholder_text(0, prompt_line)
		



func next_auto(): # Retrieve the DialogueLine this label just finished typing
	if line_is_skipped == false:
		if dialogue == load("res://Dialogues/Computer.dialogue"):
			pass
		else:
			await get_tree().create_timer(1).timeout
		_on_line_edit_text_submitted("")


func line_skipped():
	line_is_skipped = true


func line_edit_to_end():
	history_rows.remove_child(line_edit)   #removes line edit from the text's line
	history_rows.add_child(line_edit)      #places line edit to the next line
	line_edit.grab_focus()



# If the row number (amount of input_response instantiated),
# exceeds max_lines_remembered, first child gets queue freed
# doesn't work for chat_response right now, should add
func delete_history_beyond_limit():
	if history_rows.get_child_count() > max_lines_remembered:
		var rows_to_forget = history_rows.get_child_count() - max_lines_remembered
		for i in range(rows_to_forget):
			history_rows.get_child(i).queue_free()





func on_resolution_changed():
	line_edit.grab_focus()
