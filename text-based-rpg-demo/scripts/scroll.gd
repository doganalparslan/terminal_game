extends ScrollContainer

@onready var history_rows: VBoxContainer = $MarginContainer/HistoryRows
@onready var scrollbar = get_v_scroll_bar()

var scroll_max_length : int = 0

func _ready() -> void:
	scrollbar.changed.connect(handle_scrollbar_changed)
	scroll_max_length = scrollbar.max_value

func handle_scrollbar_changed():
	if scroll_max_length != scrollbar.max_value:
		scroll_max_length = scrollbar.max_value
		scroll_vertical = scroll_max_length

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("up"):
		scroll_vertical -= 50
	if Input.is_action_pressed("down"):
		scroll_vertical += 50
