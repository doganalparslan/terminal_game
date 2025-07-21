extends TabContainer

func press_enter():
	var event = InputEventKey.new()
	event.keycode = KEY_ENTER
	event.pressed = true
	Input.parse_input_event(event)


func _ready() -> void:
	Global.active_tab = get_child(0)
	get_tab_bar().focus_mode = Control.FOCUS_NONE


func _process(_delta: float) -> void:
	Global.active_tab = get_child(current_tab)
	
	#current_tab = current_tab
	#call_deferred("_grab_focus_line_edit")
	#print(FOCUS_NONE)
	
	if Input.is_action_just_pressed("tab"):
		infinite_next_tab()
	if Input.is_action_just_pressed("right"):
		next_tab()
	if Input.is_action_just_pressed("left"):
		previous_tab()
		



func _on_tab_changed(_tab: int) -> void:
	if Global.get_current_chat().name == "Computer":
		Global.go_to_this_line("Computer", "31")
	Global.active_tab = get_child(current_tab)
	call_deferred("_grab_focus_line_edit")


func _on_tab_clicked(tab: int) -> void:
	print_debug("TAB CLICKED")
	Global.active_tab = get_child(current_tab)
	call_deferred("_grab_focus_line_edit")

func _on_tab_selected(tab: int) -> void:
	print_debug("TAB SELECTED")
	Global.active_tab = get_child(current_tab)
	call_deferred("_grab_focus_line_edit")

func _on_focus_entered() -> void:
	print_debug("FOCUS ENTERED")
	Global.active_tab = get_child(current_tab)
	call_deferred("_grab_focus_line_edit")







func _grab_focus_line_edit():
	if Global.active_tab.line_edit.has_focus() == false:
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
