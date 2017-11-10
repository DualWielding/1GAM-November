extends Button

onready var rich_text = get_node("RichTextLabel")
onready var label = get_node("Label")

var option setget set_option, get_option
var speaker setget set_speaker, get_speaker

var full_text
var text

func set_option(opt):
	option = opt
	full_text = tr(option.text)
	text = tr(option.text)
	
	if Player.get_name():
		text = text.replace("%n", Player.get_name())
	
	var idx = 0
	while idx < text.length():
		if text[idx] == "[" and text[idx + 1] == "i" and text[idx + 2] == "]":
			while text[idx] != "/" or text[idx + 1] != "i" or text[idx + 2] != "]":
				text.erase(idx, 1)
			text.erase(idx, 3)
		idx += 1
	
	# Show which card is used, if the option uses one
	if opt.has("card used"):
		if typeof(option["card used"]) == TYPE_STRING:
			text = str("[", tr(Cards.get(opt["card used"]).unique_name), "] ", text)
		elif typeof(option["card used"]) == TYPE_ARRAY:
			for card in option["card used"]:
				text = str("[", tr(Cards.get(card).unique_name), "] ", text)
		
	rich_text.set_bbcode(text)
	if text.length() > 200:
		var size = Vector2(get_size().x, get_size().y * 2)
		set_size(size)
		rich_text.set_size(size)

func get_option():
	return option

func set_speaker(body):
	speaker = body

func get_speaker():
	return speaker

func _on_ClickableText_pressed():
	Player.ui.dialog_panel.script_container.set_dialog(Player.character, full_text, [], true)
	
	Player.ui.clear_answers()
	if option.has("card used"):
		if typeof(option["card used"]) == TYPE_STRING:
			Player.remove_card(option["card used"])
		elif typeof(option["card used"]) == TYPE_ARRAY:
			for card in option["card used"]:
				Player.remove_card(card)
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