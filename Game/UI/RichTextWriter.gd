extends RichTextLabel

var t = Timer.new()
var current_index
var full_text
var base_speed
var hovered = false setget set_hovered, is_hovered

var finished = true
signal finished

func _ready():
	set_scroll_follow(true)
	connect("mouse_enter", self, "set_hovered", [true])
	connect("mouse_exit", self, "set_hovered", [false])
	t.connect("timeout", self, "write")
	add_child(t)
	set_process_input(true)

func _input(event):
	if hovered\
	and !finished\
	and event.type == InputEvent.MOUSE_BUTTON\
	and event.button_index == BUTTON_LEFT\
	and event.pressed:
		append_bbcode(full_text.right(current_index))
		finish()

func write_text(text, speed = 0.07):
	finished = false
	base_speed = speed
	current_index = 0
	full_text = text.replace("%n", Player.get_name())
	t.set_wait_time(base_speed)
	t.start()

func write():
	append_bbcode(full_text[current_index])
	current_index += 1
#	set_bbcode(full_text.left(current_index))
	if current_index == full_text.length():
		finish()
#	elif full_text[current_index] == "." or full_text[current_index] == "!" or full_text[current_index] == "?":
#		t.set_wait_time(base_speed * 4)
#	else:
#		t.set_wait_time(base_speed)

func finish():
	finished = true
	append_bbcode("\n\n")
	emit_signal("finished")
	t.stop()

func set_hovered(boolean):
	hovered = boolean

func is_hovered():
	return hovered