extends Node

var dtag:= "typing sound manager: "

@onready var beep_sound: AudioStreamPlayer2D = $BeepSound
@onready var click_sound: AudioStreamPlayer2D = $ClickSound
@onready var pc_sound: AudioStreamPlayer2D = $PCSound
@onready var ambient_sound: AudioStreamPlayer2D = $AmbientSound


# ANSWER BEEP Sound Effect ----------------------------------
func on_npc_typed_one_character(_letter: String, _letter_index: int, _speed: float):
	beep_sound.volume_db = randi_range(-20, -15)
	beep_sound.pitch_scale = randf_range(0.995, 1.005)
	beep_sound.play()
	if beep_sound.is_playing() == true:
		await beep_sound.finished
		beep_sound.stop()


# KEYBOARD CLICK Sound Effect ----------------------------------
func _on_line_edit_text_changed(_new_text: String) -> void:
	click_sound.volume_db = -5
	click_sound.pitch_scale = randf_range(0.95, 1.05)
	click_sound.play()


# ENTER/RETURN Sound Effect ----------------------------------
func _on_line_edit_text_submitted(_new_text: String) -> void:
	click_sound.volume_db = 0
	click_sound.pitch_scale = 1.2
	click_sound.play()


func _on_game_booted() -> void:
	pc_sound.stream = load("res://sounds/turn_on.mp3")
	pc_sound.play()
	await pc_sound.finished
	pc_sound.stream = load("res://sounds/PC Fan.mp3")
	var infinite_number = 0
	while infinite_number == 0:
		await get_tree().create_timer(randi_range(30, 150)).timeout
		pc_sound.play()
