extends Label

var hovered = false
var option setget set_option, get_option
var speaker setget set_speaker, get_speaker

func _ready():
	set_text(tr(option["text"]))
	set_process_input(true)

func _input(event):
	if hovered\
	and event.type == InputEvent.MOUSE_BUTTON\
	and event.button_index == BUTTON_LEFT\
	and event.pressed:
		speaker.follow_up_dialog(option)

func set_option(opt):
	option = opt
	set_text(tr(option["text"]))

func get_option():
	return option

func set_speaker(body):
	speaker = body

func get_speaker():
	return speaker

func _on_ClickableText_mouse_enter():
	hovered = true

func _on_ClickableText_mouse_exit():
	hovered = false