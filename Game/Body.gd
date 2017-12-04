#extends Node2D
extends "res://Isometric-item.gd"

var sequences = {}
var state = "default" setget set_state, get_state
var display_name setget set_name, get_name
var unique_name = "Base body"
var is_object = true
var fade_timer = Timer.new()

signal say(body, text, options)
signal state_change(old_state, new_state)
signal stop_dialog

func _ready():
	can_be_interacted_with = true
	add_child(fade_timer)
	connect("state_change", self, "on_state_change")
	add_to_group("body")
	init()
	load_sequences()

func init():
	# Function to override in childs, instead of _ready
	pass

func set_state(new_state):
	emit_signal("state_change", state, new_state)
	state = new_state

func get_state():
	return state

func load_sequences():
	var path = "res://DialogSequences/" + unique_name.to_upper() + ".json"
	var file = File.new()
	
	if !file.file_exists(path):
		path = "res://DialogSequences/DEFAULT.json"
	
	file.open(path, file.READ)
	var text = file.get_as_text()
	sequences.parse_json(text)
	file.close()

func start_dialog():
	# Stop the player's movement while interacting
	Player.character.set_disabled_movement(true)
	
	say(tr(sequences[state]["text"]), sequences[state]["options"])
	
	Player.ui.dialog_panel.disable_toggling()

func follow_up_dialog(option):
	if option["end"]:
		stop_dialog(option)
	else:
		var sequence_name = option["next sequence"]
		say(tr(sequences[sequence_name]["text"]), sequences[sequence_name]["options"])

func stop_dialog(option):
	# Re-enable the character movement
	Player.character.set_disabled_movement(false)
	
	# The state change is done in clickable text
	emit_signal("stop_dialog")

func say(text, opt):
	var to_remove = []
	var options = []
	
	for option in opt:
		# Remove a dialog option the player does not have the right tool
		# or if he already used that option
#		if !Player.is_unique_answer_up(option.text):
#			options.append(option)
		if !option.has("card used"):
			options.append(option)
		elif option.has("card used") and typeof(option["card used"]) == TYPE_STRING and Player.has_card(option["card used"]):
			options.append(option)
		elif option.has("card used") and typeof(option["card used"]) == TYPE_ARRAY:
			var add = true
			for card in option["card used"]:
				if !Player.has_card(card):
					add = false
					break
			if add:
				options.append(option)
	
	# We need the body param in order to send the player's answer back to the body
	# Thus enabling us to follow up with the next dialog line
	emit_signal("say", self, text, options)

func enter():
	fade_in()

func out():
	fade()

func set_name(name):
	display_name = name

func get_name():
	return display_name

func get_display_name():
	return get_name()

func fade():
	Player.character.remove_interaction_possibility(self)
	can_be_interacted_with = false
	get_node("FadePlayer").play("Fade")
	get_node("FadePlayer").connect("finished", self, "queue_free")

func fade_in():
	get_node("FadePlayer").play_backwards("Fade")
	fade_timer.set_wait_time(0.1)
	fade_timer.connect("timeout", self, "show", [], CONNECT_ONESHOT)
	fade_timer.start()

func on_state_change(old_state, new_state):
	if new_state == "neutralized":
		fade()