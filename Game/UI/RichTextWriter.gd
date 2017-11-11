extends RichTextLabel

onready var ap = get_node("AnimationPlayer")

var t = Timer.new()

var _current_visible_text_idx = 0
var _current_real_text_idx = 0

var full_text
var clean_text
var method = "fade"
var base_speed
var hovered = false setget set_hovered, is_hovered

var finished = false setget is_finished

signal finished

func _ready():
	connect("mouse_enter", self, "set_hovered", [true])
	connect("mouse_exit", self, "set_hovered", [false])
	t.connect("timeout", self, "_write")
	add_child(t)
	set_process_input(true)
	start()

func start():
	if method == "fade":
		_fade_text(false)
	elif method == "fade_fast":
		_fade_text(true)
	else: # method == "write"
		_write_text()
	show()

func _input(event):
	if hovered\
	and event.type == InputEvent.MOUSE_BUTTON\
	and event.button_index == BUTTON_LEFT\
	and event.pressed:
		get_parent().get_parent().show_last()

func _fade_text(fast):
	if fast:
		ap.play("fade_in", -1, 2)
	else:
		ap.play("fade_in")
	ap.connect("finished", self, "finish")

func _write_text(speed = 0.025):
	ap.play("fade_in", -1 , 50)
	finished = false
	base_speed = speed
	set_visible_characters(0)
	_current_real_text_idx = 0
	_current_visible_text_idx = 0
	t.set_wait_time(base_speed)
	t.start()

func _write():
	if _current_real_text_idx >= full_text.length():
		finish()
		return
	
	var char = full_text[_current_real_text_idx]
	
	if char == "[":
		while full_text[_current_real_text_idx] != "]":
			_current_real_text_idx += 1
		_current_real_text_idx == 1 # for the "]"
		
		while full_text[_current_real_text_idx] !=  "[":
			_current_real_text_idx += 1
			_current_visible_text_idx += 1
		
		while full_text[_current_real_text_idx] != "]":
			_current_real_text_idx += 1
		_current_real_text_idx += 1 # for "]"
		
	elif char == "." or char == "!" or char == "?":
		t.set_wait_time(0.5)
	elif char == "," or char == "!" or char == "?":
		t.set_wait_time(0.2)
	else:
		t.set_wait_time(base_speed)
	set_visible_characters(_current_visible_text_idx)
	_current_real_text_idx += 1
	_current_visible_text_idx += 1

func set_text_up(text, method):
	full_text = text.replace("%n", Player.get_name())
	set_bbcode(full_text)
#	clean_text = get_raw_text()
	self.method = method
	hide()

func is_finished():
	return finished

func finish():
	set_visible_characters(-1)
	finished = true
	emit_signal("finished")
	t.stop()

func set_hovered(boolean):
	hovered = boolean

func is_hovered():
	return hovered