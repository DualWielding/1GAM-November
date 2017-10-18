extends RichTextLabel

var t = Timer.new()
var current_index
var full_text
var base_speed
var hovered = false

signal finished

func _ready():
	connect("mouse_enter", self, "_on_RightTextWriter_mouse_enter")
	connect("mouse_exit", self, "_on_RightTextWriter_mouse_exit")
	t.connect("timeout", self, "write")
	add_child(t)
	set_process_input(true)

func _input(event):
	if hovered\
	and event.type == InputEvent.MOUSE_BUTTON\
	and event.button_index == BUTTON_LEFT\
	and event.pressed:
		set_bbcode(full_text)
		finish()

func write_text(text, speed = 0.07):
	base_speed = speed
	current_index = 0
	full_text = text
	t.set_wait_time(base_speed)
	t.start()

func write():
	current_index += 1
	set_bbcode(full_text.left(current_index))
	if current_index == full_text.length():
		finish()
	elif full_text[current_index] == "." or full_text[current_index] == "!" or full_text[current_index] == "?":
		t.set_wait_time(base_speed * 4)
	else:
		t.set_wait_time(base_speed)

func finish():
	emit_signal("finished")
	t.stop()

func _on_RightTextWriter_mouse_enter():
	hovered = true

func _on_RightTextWriter_mouse_exit():
	hovered = false