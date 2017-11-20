extends CanvasLayer

onready var interaction_button = get_node("InteractionButton")
onready var dialog_panel = get_node("DialogPanel")
onready var important_hand = get_node("ImportantHand")
onready var hand = get_node("Hand")
onready var input_wrapper = get_node("InputWrapper")
onready var input_field = input_wrapper.get_node("InputField")
onready var submit_button = input_wrapper.get_node("Submit")
onready var discard_panel = get_node("DiscardPanel")
onready var discard_button = discard_panel.get_node("DiscardButton")
onready var discard_label = discard_panel.get_node("DiscardLabel")

var ui_card_class = preload("res://UI/UICard.tscn")
var ui_important_card_class = preload("res://UI/UIImportantCard.tscn")

var cards_to_discard_number = 0
var cards_to_discard = []

func _ready():
	Input.set_custom_mouse_cursor(load("res://Sprites/Cursor.png"))
	Player.ui = self
	hide()
	
	# Connect to player
	Player.character.connect("can_interact", self, "show_interaction_button")
	Player.character.connect("cant_interact", self, "hide_interaction_button")
	Player.connect("card_added", self, "add_card")
	Player.connect("card_removed", self, "remove_card")
	
	Player.add_base_cards()
	
	# Connect the UI to every bodies in the scene
	for body in get_tree().get_nodes_in_group("body"):
		body.connect("say", self, "show_dialog")
		body.connect("stop_dialog", self, "hide_dialog")
		body.connect("stop_dialog", Player, "check_cards_number")
		body.connect("stop_dialog", dialog_panel, "reset_current_options")
	
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
#	discard_button.set_text(tr("DISCARD BUTTON"))
	
	
	set_process_input(true)

###### DIALOGS ######

func show_dialog(body, unformatted_text, options):
	# Hide the interaction button
	hide_interaction_button()
	dialog_panel.set_dialog(body, unformatted_text, options)
	# This two next are now handled by set_dialog func
#	dialog_panel.show_panel()
#	dialog_panel.disable_toggling()

func hide_dialog():
	# Show the interaction button again
	dialog_panel.clear_answers()
	dialog_panel.hide_panel()
	dialog_panel.enable_toggling()
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
		for i in range(size):
			var body = Player.character.interaction_possibilities[i]
			popup.add_item(body.get_name(), i)
			popup.connect("item_pressed", self, "send_start_interaction_message")
		popup.show()
		popup.set_pos(get_viewport().get_mouse_pos() + Vector2(-10, -10))

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

func bring_card_up(card):
	# ui_card means important AND normal cards
	for child in get_tree().get_nodes_in_group("ui_card"):
		if card.unique_name == child.unique_name:
			child.bring_up()

func lower_card(card):
	for child in get_tree().get_nodes_in_group("ui_card"):
		if card.unique_name == child.unique_name:
			child.lower()

func add_card(card_data, animated=true):
	if card_data == null:
		return false
	
	var card
	
	if card_data.has("important") and card_data.important:
		card = ui_important_card_class.instance()
		card.init_from_dic(card_data)
		important_hand.add_child(card)
		card.show_card(animated)
	else:
		card = ui_card_class.instance()
		card.init_from_dic(card_data)
		hand.add_child(card)
		card.show_card()
	return true

func remove_card(card, animated=true):
	for child in get_tree().get_nodes_in_group("ui_card"):
		if card.unique_name == child.unique_name:
			child.discard(animated)
			return true
	return false

	### NORMAL ###

# ATM only useful for discarding, so it's only taking normal cards into account
func bring_cards_up():
	for child in get_tree().get_nodes_in_group("ui_normal_card"): 
		if child.is_up():
			child.lower()
		child.set_selectable(true)
	hand.get_node("AnimationPlayer").play("bring_up")

# ATM only useful for discarding, so it's only taking normal cards into account
func lower_cards():
	hand.get_node("AnimationPlayer").play_backwards("bring_up")
	for child in get_tree().get_nodes_in_group("ui_normal_card"):
		child.set_selectable(false)
		child.set_selected(false)

	### DISCARD ###

func add_to_discard_stash(card):
	if cards_to_discard_number > 0:
		cards_to_discard.append(card)
		cards_to_discard_number -= 1
		return true
	else:
		return false

func remove_from_discard_stash(card):
	cards_to_discard.remove(cards_to_discard.find(card))
	cards_to_discard_number += 1

func show_discard_screen(number):

	var text = tr("DISCARD TEXT").replace("%number", str(number))
	if number == 1:
		text = text.replace("cartes", "carte")
		text = text.replace("surnuméraires", "surnuméraire")
	
	discard_label.set_text(text)
	cards_to_discard_number = number
	bring_cards_up()
	hand.get_node("AnimationPlayer").connect("finished", discard_panel, "show", [], CONNECT_ONESHOT)
	Player.character.set_disabled_movement(true)

func hide_discard_screen():
	lower_cards()
	discard_panel.hide()
	Player.character.set_disabled_movement(false)

func _on_DiscardButton_pressed():
	for card in cards_to_discard:
		Player.remove_card(card.unique_name)
	if cards_to_discard_number == 0:
		hide_discard_screen()
		
	discard_label.set_text(tr("DISCARD TEXT").replace("%number", str(cards_to_discard_number)))

func hide():
	interaction_button.hide()
	hand.hide()
	important_hand.hide()
	dialog_panel.hide()

func show():
	interaction_button.show()
	hand.show()
	important_hand.show()
	dialog_panel.show()
# Test for discarding
#func _on_Button_toggled( pressed ):
#	if pressed:
#		show_discard_screen(2)
#	else:
#		hide_discard_screen()