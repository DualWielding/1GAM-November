extends Control

var initial_card

var name = "Test"
var unique_name = "Test"
var text = "Test"
var img = preload("res://Sprites/Floor.png")
var important = false

var _hovered = false
var _up = false setget set_up, is_up
var _recto = true

var selectable = false setget set_selectable, is_selectable
var selected = false setget set_selected, is_selected

onready var aura = get_node("Wrapper/Aura")
onready var recto = get_node("Wrapper/VirginCard/Recto")
onready var verso = get_node("Wrapper/VirginCard/Verso")

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
	get_node("Wrapper/VirginCard/Recto/Name").set_text(name)
	get_node("Wrapper/VirginCard/Recto/Picture").set_texture(img)
	get_node("Wrapper/VirginCard/Verso/Text").set_text(text)
	
	hide()
	
	set_process_input(true)

func _input(event):
	if _hovered\
	and event.type == InputEvent.MOUSE_BUTTON\
	and event.button_index == BUTTON_RIGHT\
	and event.pressed:
		if _up or selectable:
			if _recto:
				view_verso()
			else:
				view_recto()

func discard(animated=true):
	if animated:
		animate_discard()
		ap.connect("finished", self, "queue_free", [], CONNECT_ONESHOT)
	else:
		queue_free()

func show_card(animate=true, recto=true):
	if animate:
		animate_add()
	if recto:
		self.recto.show()
		verso.hide()
	else:
		verso.show()
		self.recto.hide()
	show()

##### SELECTION #####

# This is only for discard purposes ATM

func set_selectable(boolean):
	get_node("Wrapper/VirginCard").set_pressed(false)
	selectable = boolean

func is_selectable():
	return selectable

func set_selected(boolean):
	# Set the card as selected
	if boolean:
		if Player.ui.add_to_discard_stash(initial_card): # Selection worked
			aura.show()
			selected = boolean
		else: # Selection failed (no more card to select)
			# reset the button status
			get_node("Wrapper/VirginCard").set_pressed(false)
	else:
		aura.hide()
		Player.ui.remove_from_discard_stash(initial_card)
		selected = boolean

func is_selected():
	return selected


##### ANIMATIONS #####

func animate_add():
	_up = true
	ap.play("animate_add", -1, 0.8)

func animate_discard():
	ap.play_backwards("animate_add")

func bring_up():
	if !selectable:
		ap.play("bring_up")
		_up = true

func lower():
	if !selectable:
		ap.play_backwards("bring_up")
		_up = false

func set_up(boolean):
	_up = boolean

func is_up():
	return _up

func view_recto():
	ap.play_backwards("turn")
	_recto = true

func view_verso():
	ap.play("turn")
	_recto = false

func _on_VirginCard_toggled( pressed ):
	if is_selectable():
		set_selected(pressed)
	else:
		if _up:
			lower()
		else:
			bring_up()

func _on_VirginCard_mouse_enter():
	_hovered = true

func _on_VirginCard_mouse_exit():
	_hovered = false