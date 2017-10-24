extends Button

onready var rich_text = get_node("RichTextLabel")
onready var label = get_node("Label")

var option setget set_option, get_option
var speaker setget set_speaker, get_speaker

var text

func set_option(opt):
	option = opt
	text = tr(option.text)
	if Player.get_name():
		text = text.replace("%n", Player.get_name())
	# Show which card is used, if the option uses one
	if opt.has("card used"):
		text = str("[", tr(Cards.get(opt["card used"]).unique_name), "] ", text)
	rich_text.set_bbcode(text)

func get_option():
	return option

func set_speaker(body):
	speaker = body

func get_speaker():
	return speaker

func _on_ClickableText_pressed():
	get_parent().get_parent().get_node("SpeakerText").append_bbcode(str("[i]", Player.get_name(), "[/i]\n\n"))
	get_parent().get_parent().get_node("SpeakerText").append_bbcode(str(text, "\n\n"))
	
	Player.ui.clear_answers()
	if option.has("card used"):
		Player.remove_card(option["card used"])
	if option.has("card gained"):
		if typeof(option["card gained"]) == TYPE_STRING:
			Player.add_card(option["card gained"])
		elif typeof(option["card gained"]) == TYPE_ARRAY:
			for card in option["card gained"]:
				Player.add_card(card)
	if option.has("unique") and option.unique:
		Player.used_unique_answer(option.text)
	if option.has("state change") and option["state change"] != "unchanged":
		speaker.set_state(option["state change"])
	speaker.follow_up_dialog(option)