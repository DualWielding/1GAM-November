extends RichTextLabel

var t = Timer.new()
var current_index
var full_text
var method = "fade"
var base_speed
var hovered = false setget set_hovered, is_hovered

var finished = true
signal finished

func _ready():
	hide()
	connect("mouse_enter", self, "set_hovered", [true])
	connect("mouse_exit", self, "set_hovered", [false])
	t.connect("timeout", self, "_write")
	add_child(t)
	set_process_input(true)
	
	if method == "fade":
		_fade_text()
	else: # method == "write"
		_write_text()

func _input(event):
	if hovered\
	and !finished\
	and event.type == InputEvent.MOUSE_BUTTON\
	and event.button_index == BUTTON_LEFT\
	and event.pressed:
		_finish()

func _fade_text():
	var ap = get_node("AnimationPlayer")
	ap.play("fade_in")
	ap.connect("finished", self, "_finish")
	show()

func _write_text(speed = 0.025):
	finished = false
	base_speed = speed
	set_visible_characters(0)
	current_index = 0
	t.set_wait_time(base_speed)
	t.start()
	show()

func _write():
	set_visible_characters(current_index)
#	set_bbcode(full_text.left(current_index))
	if current_index == full_text.length():
		_finish()
	elif full_text[current_index] == "." or full_text[current_index] == "!" or full_text[current_index] == "?":
		t.set_wait_time(0.5)
	elif full_text[current_index] == "," or full_text[current_index] == "!" or full_text[current_index] == "?":
		t.set_wait_time(0.2)
	else:
		t.set_wait_time(base_speed)
	current_index += 1

func set_text_up(text, method):
	full_text = text.replace("%n", Player.get_name())
	set_bbcode(full_text)
	self.method = method

func _finish():
	set_visible_characters(-1)
	finished = true
	emit_signal("finished")
	t.stop()

func set_hovered(boolean):
	hovered = boolean

func is_hovered():
	return hovered