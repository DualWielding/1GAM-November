extends Node2D

var sequences = {}
var state = "default" setget set_state, get_state
var display_name setget set_name, get_name
var unique_name = "Base body"
var is_object = true

signal say(body, text, options)
signal state_change(old_state, new_state)
signal stop_dialog

func _ready():
	connect("state_change", self, "check_neutralized")
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
	if option["state change"] != "unchanged":
		state = option["state change"]
	
	if option["end"]:
		stop_dialog(option)
	else:
		var sequence_name = option["next sequence"]
		say(tr(sequences[sequence_name]["text"]), sequences[sequence_name]["options"])

func stop_dialog(option):
	# Re-enable the character movement
	Player.character.set_disabled_movement(false)
	
	if option["state change"] != "unchanged":
		state = option["state change"]
	emit_signal("stop_dialog")
	
	Player.ui.dialog_panel.enable_toggling()

func say(text, opt):
	var to_remove = []
	var options = opt
	
	for option in options:
		# Remove a dialog option the player does not have the right tool
		# or if he already used that option
		if !Player.is_unique_answer_up(option.text):
			to_remove.append(option)
		elif option.has("card used") and typeof(option["card used"]) == TYPE_STRING and !Player.has_card(option["card used"]):
			to_remove.append(option)
		elif option.has("card used") and typeof(option["card used"]) == TYPE_ARRAY:
			for card in option["card used"]:
				if !Player.has_card(card):
					to_remove.append(option)
	
	for option in to_remove:
		options.remove(options.find(option))
	
	# We need the body param in order to send the player's answer back to the body
	# Thus enabling us to follow up with the next dialog line
	emit_signal("say", self, text, options)

func set_name(name):
	display_name = name

func get_name():
	return display_name

func fade():
	get_node("FadePlayer").play("Fade")
	get_node("FadePlayer").connect("finished", self, "queue_free")

func fade_in():
	show()
	get_node("FadePlayer").play_backwards("Fade")

func check_neutralized(old_state, new_state):
	if new_state == "neutralized":
		fade()