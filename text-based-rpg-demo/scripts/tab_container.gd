extends TabContainer

func press_enter():
	var event = InputEventKey.new()
	event.keycode = KEY_ENTER
	event.pressed = true
	Input.parse_input_event(event)


func _ready() -> void:
	Global.active_tab = get_child(0)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("tab"):
		infinite_next_tab()
	if Input.is_action_just_pressed("right"):
		next_tab()
	if Input.is_action_just_pressed("left"):
		previous_tab()
		

func _on_tab_changed(_tab: int) -> void:
	Global.active_tab = get_child(current_tab)
	call_deferred("_grab_focus_line_edit")

func _grab_focus_line_edit():
	Global.active_tab.line_edit.grab_focus()


func infinite_next_tab():
	if current_tab >= get_tab_count() - 1:
		current_tab = 0
	else:
		current_tab = current_tab + 1


func next_tab():
	if current_tab < get_tab_count() - 1:
		current_tab = current_tab + 1
		press_enter()


func previous_tab():
	if current_tab == 0:
		return
	else:
		current_tab = current_tab - 1
		press_enter()
