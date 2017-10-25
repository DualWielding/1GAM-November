extends Control

var initial_card

var name = "Test"
var unique_name = "Test"
var text = "Test"
var img = preload("res://Sprites/Floor.png")
var important = false

var selectable = false setget set_selectable, is_selectable
var selected = false setget set_selected, is_selected

onready var aura = get_node("Aura")

onready var ap = get_node("AnimationPlayer")

func init_from_dic(dic):
	# This is mostly for interacting with functions taking the data-style card
	# such as add_card or remove_card of the UI, which get their parameters from dialogs
	initial_card = dic
	
	name = tr(dic.unique_name)
	text = dic.text
	img = dic.img
	unique_name = dic.unique_name
	if dic.has("important") and dic.important:
		important = true
		add_to_group("ui_important_card")
	else:
		add_to_group("ui_normal_card")
	add_to_group("ui_card")

func _ready():
	get_node("VirginCard/Name").set_text(name)
	get_node("VirginCard/Picture").set_texture(img)
	get_node("VirginCard/Text").set_text(text)

##### SELECTION #####

# This is only for discard purposes ATM

func set_selectable(boolean):
	get_node("VirginCard").set_pressed(false)
	selectable = boolean

func is_selectable():
	return selectable

func set_selected(boolean):
	if boolean:
		aura.show()
		Player.ui.add_to_discard_stash(initial_card)
	else:
		aura.hide()
		Player.ui.remove_from_discard_stash(initial_card)
	selected = boolean

func is_selected():
	return selected


##### ANIMATIONS #####

func bring_up():
	ap.play("bring_up")

func lower():
	ap.play_backwards("lower")

func _on_VirginCard_toggled( pressed ):
	if Player.ui.cards_to_discard_number == 0 and pressed:
		get_node("VirginCard").set_pressed(false)
		return
	if is_selectable():
		set_selected(pressed)
