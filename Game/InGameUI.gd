extends Control

onready var interaction_button = get_node("InteractionButton")
onready var hand_scale_button = get_node("HandScaleButton")
onready var dialog_panel = get_node("DialogPanel")
onready var hand = get_node("Hand")
onready var input_wrapper = get_node("InputWrapper")
onready var input_field = input_wrapper.get_node("InputField")
onready var submit_button = input_wrapper.get_node("Submit")

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
	interaction_button.set_shortcut(sc)
	interaction_button.get_popup().set_light_mask(interaction_button.get_light_mask())
	
	
	# # Set the translations
	interaction_button.set_tooltip(tr("INTERACTION BUTTON TOOLTIP"))
	interaction_button.set_text(tr("INTERACTION BUTTON"))
	hand_scale_button.set_tooltip(tr("HAND SCALE BUTTON TOOLTIP"))
	
	set_process_input(true)

###### DIALOGS ######

func show_dialog(body, unformatted_text, options):
	# Hide the interaction button
	hide_interaction_button()
	dialog_panel.set_dialog(body, unformatted_text, options)
	dialog_panel.show()

func hide_dialog():
	# Show the interaction button again
	dialog_panel.clear_answers()
	dialog_panel.hide()
	show_interaction_button()

func clear_answers():
	dialog_panel.clear_answers()

###### INTERACTIONS ######

func show_interaction_button():
	if !Player.character.is_disabled():
		interaction_button.set_disabled(false)

func hide_interaction_button():
	interaction_button.set_disabled(true)
	interaction_button.get_popup().hide()
	interaction_button.get_popup().clear()

func _on_InteractionButton_pressed():
	var popup = interaction_button.get_popup()
	popup.clear()
	var size = Player.character.interaction_possibilities.size()
	if size == 1:
		send_start_interaction_message(0)
	else:
		for i in range():
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
	var b = hand_scale_button
	if pressed:
		hand.set_scale(Vector2(0.3, 0.3))
		b.set_text("v")
	else:
		hand.set_scale(Vector2(1, 1))
		b.set_text("^")