extends LineEdit

var placeholder_label = RichTextLabel.new()
var stored_placeholder_text: String
var updated_label_text: String

var how_many_times: int = 1
var new_placeholder
var delete_placeholder

func _ready() -> void:
	caret_blink = true

	add_child(placeholder_label)
	placeholder_label.set_theme_type_variation("Preview")
	placeholder_label.fit_content = true
	placeholder_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	placeholder_label.set_autowrap_mode(TextServer.AUTOWRAP_OFF)
	placeholder_label.size = size



func _on_text_submitted(_new_text: String) -> void:
	clear()
	how_many_times = 0
	placeholder_label.add_theme_color_override("default_color", get_theme_color("font_color") * Color(1,1,1, 0.5) )



func create_placeholder_text(await_time, preview_text: String):
	var tween = get_tree().create_tween()
	placeholder_label.visible_ratio = 0
	stored_placeholder_text = preview_text
	placeholder_label.text = preview_text
	tween.tween_property(placeholder_label,"visible_ratio", 1, await_time)


func _on_text_changed(new_text: String) -> void:
	var delete_pressed = (how_many_times - new_text.length()) / 2
	
	if delete_pressed > 1 and new_text.length() < stored_placeholder_text.length():
		delete_placeholder = stored_placeholder_text.right(stored_placeholder_text.length() - (new_text.length()))
		placeholder_label.text = " ".repeat(new_text.length()) + delete_placeholder
	else:
		placeholder_label.text = placeholder_label.text.right(placeholder_label.text.length() - (new_text.length()))
		new_placeholder = placeholder_label.text
		placeholder_label.text = " ".repeat(new_text.length()) + new_placeholder
	
	how_many_times += 1



# Forces caret to be positioned after the last character always
func _physics_process(_delta: float) -> void:
	caret_column = get_text().length()



#---------------------------------------------------------MOBILE KEYBOARD
#func _on_focus_entered() -> void:
	#DisplayServer.virtual_keyboard_show("")
#
#
#
#func _on_focus_exited() -> void:
	#DisplayServer.virtual_keyboard_hide()
