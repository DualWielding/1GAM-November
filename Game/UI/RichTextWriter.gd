extends RichTextLabel

var t = Timer.new()

var _current_visible_text_idx = 0
var _current_real_text_idx = 0

var full_text
var clean_text
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
	_current_real_text_idx = 0
	_current_visible_text_idx = 0
	t.set_wait_time(base_speed)
	t.start()
	show()

func _write():
	if _current_real_text_idx >= full_text.length():
		_finish()
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

#func get_raw_text():
#	var raw_text = ""
#	var ignoring = false
#	for i in range(full_text.length()):
#		if full_text[i] == "[":
#			ignoring = true
#		elif i != 0 and full_text[i-1] == "]":
#			ignoring = false
#		
#		if !ignoring:
#			raw_text = str(raw_text, full_text[i])
#	return raw_text

func _finish():
	set_visible_characters(-1)
	finished = true
	emit_signal("finished")
	t.stop()

func set_hovered(boolean):
	hovered = boolean

func is_hovered():
	return hovered