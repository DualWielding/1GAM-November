extends ScrollContainer

var hovered = false
onready var script_container = get_node("ScriptContainer")

var _scroll_timer = Timer.new() setget get_scroll_timer
var _last_scroll_tick = 0

func _ready():
	set_process_unhandled_input(true)
	
	_scroll_timer.set_wait_time(0.04)
	add_child(_scroll_timer)
	_scroll_timer.connect("timeout", self, "auto_scroll_down")

func _unhandled_input(event):
	if event.type == InputEvent.MOUSE_BUTTON\
	and event.button_index == BUTTON_LEFT\
	and event.pressed\
	and script_container.get_child_count() > 0:
		script_container.show_last()

func auto_scroll_down():
	set_v_scroll(get_v_scroll() + 6)
	if _last_scroll_tick == get_v_scroll():
		_scroll_timer.stop()
	_last_scroll_tick = get_v_scroll()

func start_scrolling():
	_scroll_timer.start()

func stop_scrolling():
	_scroll_timer.stop()

func get_scroll_timer():
	return _scroll_timer