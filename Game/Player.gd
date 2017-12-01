extends Node

var name = tr("STARTING PLAYER NAME") setget set_name, get_name
var display_name = tr("STARTING PLAYER NAME")
var character
var ui

var hand = {} setget get_hand
var important_hand = {} setget get_important_hand
var max_cards = 4

var base_cards = ["DAGGER", "GOLD POUCH", "POWDER", "LOVE LETTER", "LOYALIST QUEST"]

var unique_answers_used = {}

signal card_added(card)
signal card_removed(card)

func set_name(n):
	name = n
	display_name = n

func get_name():
	return name

func get_display_name():
	return display_name

###### DIALOGS ######

func used_unique_answer(untraslated_text):
	unique_answers_used[untraslated_text] = true

func is_unique_answer_up(untranslated_text):
	return !unique_answers_used.has(untranslated_text)

###### CARDS ######

func add_base_cards():
	# Add all the players' cards at the beginning
	for card_name in base_cards:
		add_card(card_name)

func get_hand():
	return hand

func get_important_hand():
	return important_hand

func has_card(card_name):
	return hand.has(card_name) || important_hand.has(card_name)

func check_cards_number():
	if hand.values().size() > max_cards:
		var last_card = ui.hand.get_children()[ui.hand.get_child_count() - 1]
		if last_card.ap.is_playing():
			last_card.ap.connect("finished", ui, "show_discard_screen", [hand.keys().size() - max_cards], CONNECT_ONESHOT)
		else:
			ui.show_discard_screen(hand.keys().size() - max_cards)

func add_card(card_unique_name):
	var card = Cards.get(card_unique_name)
	
	if card.has("important") and card.important:
		important_hand[card_unique_name] = card
	else:
		hand[card_unique_name] = card
	emit_signal("card_added", card)

func remove_card(card_unique_name, animated=true):
	emit_signal("card_removed", Cards.get(card_unique_name), animated)
	if hand.has(card_unique_name):
		hand.erase(card_unique_name)
	elif important_hand.has(card_unique_name):
		important_hand.erase(card_unique_name)