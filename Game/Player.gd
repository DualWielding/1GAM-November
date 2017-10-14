extends Node

var character
var ui

var hand = {} setget get_hand

signal card_added(card)
signal card_removed(card)

func _ready():
	add_card(Cards.get("DAGGER"))
	add_card(Cards.get("POUCH"))

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