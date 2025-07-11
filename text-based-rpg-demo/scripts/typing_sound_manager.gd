extends Node

@onready var beep_sound: AudioStreamPlayer = $BeepSound
@onready var click_sound: AudioStreamPlayer = $ClickSound
@onready var pc_sound: AudioStreamPlayer = $PCSound
@onready var ambient_sound: AudioStreamPlayer = $AmbientSound


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



# ELECTRIC HUMMING Sound Effect ----------------------------------
func electric_humm_db(db: int = 0):
	var tween = get_tree().create_tween()
	var initial_db: float = 0
	if db == 0:
		initial_db = randf_range(-8, 4)
	else:
		initial_db = db
	tween.tween_property(ambient_sound, "volume_db", initial_db, 3)
	print_debug("electric humm db= " + str(ambient_sound.volume_db))


# TERMINAL/PC FAN - PC Sound Effects ----------------------------------
func _on_game_booted() -> void:
	pc_sound.stream = load("res://sounds/turn_on.mp3")
	pc_sound.play()
	await pc_sound.finished
	var infinite_number = 0
	while infinite_number == 0:
		pc_sound.stream = load("res://sounds/PC_Fan.mp3")
		await get_tree().create_timer(randi_range(30, 150)).timeout
		electric_humm_db()
		print_debug("PC_Fan sound played, electric humm db_change called")
		pc_sound.play()
		await pc_sound.finished
