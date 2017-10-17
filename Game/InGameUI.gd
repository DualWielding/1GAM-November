extends Control

onready var dialog_panel = get_node("DialogPanel")
onready var answers_container = dialog_panel.get_node("AnswersContainer")
onready var body_text_window = dialog_panel.get_node("BodyTextWindow")
onready var hand = get_node("Hand")
onready var input_wrapper = get_node("InputWrapper")
onready var input_field = input_wrapper.get_node("InputField")
onready var submit_button = input_wrapper.get_node("Submit")

var clickable_label_class = preload("res://ClickableText.tscn")
var ui_card_class = preload("res://UICard.tscn")

func _ready():
	Player.ui = self
	
	# Connect to player
	Player.character.connect("can_interact", self, "show_interaction_button")
	Player.character.connect("cant_interact", self, "hide_interaction_button")
	Player.connect("card_added", self, "add_card")
	Player.connect("card_removed", self, "remove_card")
	
	# Add all the players' cards at the beginning
	for card_name in Player.get_hand():
		add_card(Player.get_hand()[card_name])
	
	# Connect the UI to every bodies in the scene
	for body in get_tree().get_nodes_in_group("body"):
		body.connect("say", self, "show_dialog")
		body.connect("stop_dialog", self, "hide_dialog")
	
	# Assign the shortcut "E" to the interaction action
	var hotkey = InputEvent()
	hotkey.type = InputEvent.KEY
	hotkey.scancode = KEY_E
	var sc = ShortCut.new()
	sc.set_shortcut(hotkey)
	get_node("InteractionButton").set_shortcut(sc)
	get_node("InteractionButton").get_popup().set_light_mask(get_node("InteractionButton").get_light_mask())
	
	# Set the visible buttons text
	submit_button.set_text(tr("SUBMIT BUTTON"))
	
	# Create the cards
	for card in Player.hand:
		var c = ui_card_class.instance()
		c.init_from_dic(card)
		hand.add_child(c)
	
	set_process_input(true)

###### DIALOGS ######

func show_dialog(body, unformatted_text, options):
	# Remplace every %n in dialogs with the player name
	var text = unformatted_text
	if Player.get_name():
		text = unformatted_text.replace("%n", Player.get_name())
	
	# Hide the interaction button
	get_node("InteractionButton").hide()
	
	# Set the new speaker's text
	body_text_window.set_bbcode(text)
	
	# Add new answers
	for option in options:
		var cl = clickable_label_class.instance()
		cl.add_to_group("dialog option")
		cl.set_speaker(body)
		cl.set_option(option)
		answers_container.add_child(cl)
	dialog_panel.show()

func hide_dialog():
	# Show the interaction button again
	clear_answers()
	dialog_panel.hide()
	show_interaction_button()

func clear_answers():
	for answer in answers_container.get_children():
		answer.queue_free()

func show_interaction_button():
	if !Player.character.is_disabled():
		get_node("InteractionButton").show()

func hide_interaction_button():
	get_node("InteractionButton").hide()
	get_node("InteractionButton").get_popup().hide()
	get_node("InteractionButton").get_popup().clear()

func _on_InteractionButton_pressed():
	var popup = get_node("InteractionButton").get_popup()
	popup.clear()
	for i in range(Player.character.interaction_possibilities.size()):
		var body = Player.character.interaction_possibilities[i]
		var b = Button.new()
		popup.add_item(body.get_name(), i)
		popup.connect("item_pressed", self, "send_start_interaction_message")
	popup.show()
	popup.set_global_pos(get_global_mouse_pos())

func send_start_interaction_message(id):
	Player.character.interaction_possibilities[id].start_dialog()

###### PLAYER INPUTS ######

func show_input():
	input_wrapper.show()

func hide_input():
	input_wrapper.hide()

func get_input_field():
	return input_field

func get_submit_button():
	return submit_button

###### CARDS ######

func add_card(card_data):
	if card_data == null:
		return false
	
	var card = ui_card_class.instance()
	card.init_from_dic(card_data)
	hand.add_child(card)
	return true

func remove_card(card):
	for child in hand.get_children():
		if card.unique_name == child.unique_name:
			hand.remove_child(child)
			return true
	return false

func _on_HandScaleButton_toggled( pressed ):
	var b = get_node("HandScaleButton")
	if pressed:
		hand.set_scale(Vector2(0.3, 0.3))
		b.set_text("v")
	else:
		hand.set_scale(Vector2(1, 1))
		b.set_text("^")