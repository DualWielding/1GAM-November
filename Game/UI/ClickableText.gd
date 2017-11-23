extends Button

onready var rich_text = get_node("RichTextLabel")
onready var label = get_node("Label")

var option setget set_option, get_option
var speaker setget set_speaker, get_speaker

var full_text
var text_alone
var used_text

func set_option(opt):
	option = opt
	full_text = tr(option.text)
	used_text = tr(option.text)
	text_alone
	
	if Player.get_name():
		used_text = used_text.replace("%n", Player.get_name())
		used_text = used_text.replace("%N", Player.get_name().to_upper())
	
		# Show which card is used, if the option uses one
	if opt.has("card used"):
		if typeof(option["card used"]) == TYPE_STRING:
			used_text = str("[", tr(Cards.get(opt["card used"]).unique_name), "] ", used_text)
		elif typeof(option["card used"]) == TYPE_ARRAY:
			for card in option["card used"]:
				used_text = str("[", tr(Cards.get(card).unique_name), "] ", used_text)
	
	# Remove stage-directions
	var idx = 0
	while idx < used_text.length():
		if used_text[idx] == "[" and used_text[idx + 1] == "i" and used_text[idx + 2] == "]":
			while used_text[idx] != "/" or used_text[idx + 1] != "i" or used_text[idx + 2] != "]":
				used_text.erase(idx, 1)
			used_text.erase(idx, 3)
		idx += 1
	
	text_alone = used_text
	
	# Remove the colors tags
	idx = 0
	while  idx < text_alone.length():
		if text_alone[idx] == "["\
		and (text_alone[idx + 1] == "c" or text_alone[idx + 1] == "/")\
		and (text_alone[idx + 2] == "o" or text_alone[idx + 2] == "c"):
			while text_alone[idx] != "]":
				text_alone.erase(idx, 1)
			text_alone.erase(idx, 1)
		idx += 1
	
	rich_text.set_bbcode(used_text)

	if text_alone.length() > 60:
		var size = Vector2(get_size().x, get_size().y * (1 + (text_alone.length() / 60.0) / 2.0))
		set_custom_minimum_size(size)
		rich_text.set_custom_minimum_size(size)
	
	if text_alone.length() < 80:
		set_theme(load("res://UI/Style/Theme-Buttons-little.tres"))
	elif text_alone.length() < 160:
		set_theme(load("res://UI/Style/Theme-Buttons-medium.tres"))
	elif text_alone.length() < 250:
		set_theme(load("res://UI/Style/Theme-Buttons-big.tres"))
	else:
		set_theme(load("res://UI/Style/Theme-Buttons-fat.tres"))

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