extends Node

var name = tr("STARTING PLAYER NAME") setget set_name, get_name
var character
var ui

var hand = {} setget get_hand
var important_hand = {} setget get_important_hand
var max_cards = 4

var unique_answers_used = {}

signal card_added(card, animated)
signal card_removed(card, animated)

func _ready():
	# /!\ These cards are not added via signal, but directly in the UI _ready func
	add_card("DAGGER", false)
	add_card("GOLD POUCH", false)
	add_card("POWDER", false)
	add_card("LOVE LETTER", false)

func set_name(n):
	name = n

func get_name():
	return name

###### DIALOGS ######

func used_unique_answer(untraslated_text):
	unique_answers_used[untraslated_text] = true

func is_unique_answer_up(untranslated_text):
	return !unique_answers_used.has(untranslated_text)

###### CARDS ######

func get_hand():
	return hand

func get_important_hand():
	return important_hand

func has_card(card_name):
	return hand.has(card_name) || important_hand.has(card_name)

func check_cards_number():
	if hand.values().size() > max_cards:
		ui.show_discard_screen(hand.keys().size() - max_cards)

func add_card(card_unique_name, animated=true):
	var card = Cards.get(card_unique_name)
	
	if card.has("important") and card.important:
		important_hand[card_unique_name] = card
	else:
		hand[card_unique_name] = card
	emit_signal("card_added", card, animated)

func remove_card(card_unique_name, animated=true):
	emit_signal("card_removed", Cards.get(card_unique_name), animated)
	if hand.has(card_unique_name):
		hand.erase(card_unique_name)
	elif important_hand.has(card_unique_name):
		important_hand.erase(card_unique_name)