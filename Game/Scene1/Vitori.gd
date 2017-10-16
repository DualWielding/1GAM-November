extends "res://NPC.gd"

var option_to_save

func _ready():
	walk_right()

func init():
	set_name("Vitori")
	unique_name = "Vitori"
	base_looking_direction = "right"

# To override in order to say stuff
#func start_dialog():
#	pass

# Override the base stop_dialog function
# In order to prevent the player from moving
func stop_dialog(option):
	emit_signal("stop_dialog")
	
	if option["state change"] != "unchanged":
		state = option["state change"]
	
	walk_left()
	fade()

# Override the base say() function, in order to
# enable the capture of the player's name
func say(body, text, options):
	
	# I really don't like this way of doing it
	#But will do for now...
	if options.size() == 1 and options[0].text == "$i":
		Player.ui.show_input()
		option_to_save = options[0]
		Player.ui.get_submit_button().connect("pressed", self, "enter_player_name")
		emit_signal("say", body, text, [])
	else:
		for option in options:
			# Remove a dialog option the player does not have the right tool
			# or if he already used that option
			if option.has("card used") and !Player.has_card(option["card used"])\
			or !Player.is_unique_answer_up(option.text):
				options.remove(options.find(option))
	
	emit_signal("say", body, text, options)

func enter_player_name():
	var name = Player.ui.get_input_field().get_text()
	Player.set_name(name)
	Player.ui.hide_input()
	follow_up_dialog(option_to_save)

func fade():
	get_node("FadePlayer").play("Fade")
	get_node("FadePlayer").connect("finished", self, "end_scene")

func end_scene():
	Player.character.set_disabled_movement(false)
	queue_free()

func _on_InteractionArea_area_enter( area ):
	var body = area.get_parent()
	if body == Player.character:
		stop_walking()
		start_dialog()