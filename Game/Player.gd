extends Node

var name setget set_name, get_name
var character
var ui

var hand = {} setget get_hand

var unique_answers_used = {}

signal card_added(card)
signal card_removed(card)

func _ready():
	add_card(Cards.get("DAGGER"))
	add_card(Cards.get("POUCH"))

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

func has_card(card_name):
	return hand.has(card_name)

func add_card(card):
	hand[card.unique_name] = card

func remove_card(card_unique_name):
	hand.erase(card_unique_name)
	emit_signal("card_removed", Cards.get(card_unique_name))