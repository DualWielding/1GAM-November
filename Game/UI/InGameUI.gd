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

var cards_to_discard_number = 0
var cards_to_discard = []

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
	
	for card_name in Player.get_important_hand():
		add_card(Player.get_important_hand()[card_name])
	
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
	discard_button.set_text(tr("DISCARD BUTTON"))
	
	
	set_process_input(true)

###### DIALOGS ######

func show_dialog(body, unformatted_text, options):
	# Hide the interaction button
	hide_interaction_button()
	dialog_panel.set_dialog(body, unformatted_text, options)
	dialog_panel.show_panel()
	dialog_panel.disable_toggling()

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

func bring_card_up(card):
	# ui_card means important AND normal cards
	for child in get_tree().get_nodes_in_group("ui_card"):
		if card.unique_name == child.unique_name:
			child.bring_up()

func lower_card(card):
	for child in get_tree().get_nodes_in_group("ui_card"):
		if card.unique_name == child.unique_name:
			child.lower()

func add_card(card_data):
	if card_data == null:
		return false
	
	var card = ui_card_class.instance()
	card.init_from_dic(card_data)
	
	if card.important:
		important_hand.add_child(card)
	else:
		hand.add_child(card)
	return true

func remove_card(card):
	for child in get_tree().get_nodes_in_group("ui_card"):
		if card.unique_name == child.unique_name:
			child.get_parent().remove_child(child)
			return true
	return false

	### NORMAL ###

# ATM only useful for discarding, so it's only taking normal cards into account
func bring_cards_up():
	hand.get_node("AnimationPlayer").play("bring_up")
	for child in get_tree().get_nodes_in_group("ui_normal_card"): 
		child.set_selectable(true)

# ATM only useful for discarding, so it's only taking normal cards into account
func lower_cards():
	hand.get_node("AnimationPlayer").play_backwards("bring_up")
	for child in get_tree().get_nodes_in_group("ui_normal_card"):
		child.set_selectable(false)
		child.set_selected(false)

	### DISCARD ###

func add_to_discard_stash(card):
	cards_to_discard.append(card)
	cards_to_discard_number -= 1

func remove_from_discard_stash(card):
	cards_to_discard.remove(cards_to_discard.find(card))
	cards_to_discard_number += 1

func show_discard_screen(number):
	discard_label.set_text(tr("DISCARD TEXT"))
	cards_to_discard_number = number
	bring_cards_up()
	discard_panel.show()
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


# Test for discarding
#func _on_Button_toggled( pressed ):
#	if pressed:
#		show_discard_screen(2)
#	else:
#		hide_discard_screen()