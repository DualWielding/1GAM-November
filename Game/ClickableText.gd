extends RichTextLabel

var hovered = false
var option setget set_option, get_option
var speaker setget set_speaker, get_speaker

func _ready():
	set_process_input(true)

func _input(event):
	if hovered\
	and event.type == InputEvent.MOUSE_BUTTON\
	and event.button_index == BUTTON_LEFT\
	and event.pressed:
		Player.ui.clear_answers()
		if option.has("card used"):
			Player.remove_card(option["card used"])
		if option.has("card gained"):
			Player.add_card(option["card gained"])
		if option.has("unique") and option.unique:
			Player.used_unique_answer(option.text)
		if option.has("state change") and option["state change"] != "unchanged":
			speaker.state = option["state change"]
		speaker.follow_up_dialog(option)

func set_option(opt):
	option = opt
	var text = tr(option.text)
	if Player.get_name():
		text = text.replace("%n", Player.get_name())
	if opt.has("card used"):
		# TODO Put the translation here and not the unique name
		text = str("[", Cards.get(opt["card used"]).unique_name, "] ", text)
	set_bbcode(text)

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