extends VBoxContainer

signal next_auto
signal line_skipped

@onready var input_history: RichTextLabel = $InputHistory
@onready var response: DialogueLabel = %Response

func _ready() -> void:
	response.connect("finished_typing", self.on_line_done)


func enter_pressed():
	if response.is_typing == true:
		line_skipped.emit()
		response.skip_typing()



func create_empty_line(times):
	for i in times:
		var empty_line = RichTextLabel.new()
		empty_line.text = " "
		empty_line.fit_content = true
		add_child(empty_line)



func create_empty_lines():
	create_empty_line(3)
	move_child(get_child(3), 1)



func set_input_text(input):
	$InputHistory.text = input



func on_line_done(input_resp): # Retrieve the DialogueLine this label just finished typing
	if input_resp.dialogue_line.time == "auto":
		emit_signal("next_auto")
		return
