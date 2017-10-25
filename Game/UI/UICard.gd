extends Control

var initial_card

var name = "Test"
var unique_name = "Test"
var text = "Test"
var img = preload("res://Sprites/Floor.png")
var important = false

var _hovered = false
var _up = false

var selectable = false setget set_selectable, is_selectable
var selected = false setget set_selected, is_selected

onready var aura = get_node("Wrapper/Aura")

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
		get_node("Wrapper/VirginCard").set_modulate(Color("#9013d0"))
	else:
		add_to_group("ui_normal_card")
	add_to_group("ui_card")

func _ready():
	get_node("Wrapper/VirginCard/Name").set_text(name)
	get_node("Wrapper/VirginCard/Picture").set_texture(img)
	get_node("Wrapper/VirginCard/Text").set_text(text)
	
	set_process_input(true)

func _input(event):
	if _hovered\
	and event.type == InputEvent.MOUSE_BUTTON\
	and event.button_index == BUTTON_RIGHT\
	and event.pressed:
		if _up:
			lower()
		else:
			bring_up()

##### SELECTION #####

# This is only for discard purposes ATM

func set_selectable(boolean):
	get_node("Wrapper/VirginCard").set_pressed(false)
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
	if !selectable:
		ap.play("bring_up")
		_up = true
		_hovered = false

func lower():
	if !selectable:
		ap.play_backwards("bring_up")
		_up = false
		_hovered = false

func _on_VirginCard_toggled( pressed ):
	if Player.ui.cards_to_discard_number == 0 and pressed:
		get_node("Wrapper/VirginCard").set_pressed(false)
		return
	if is_selectable():
		set_selected(pressed)

func _on_VirginCard_mouse_enter():
	_hovered = true

func _on_VirginCard_mouse_exit():
	_hovered = false
