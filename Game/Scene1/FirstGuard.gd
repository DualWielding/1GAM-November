extends "res://NPC.gd"

func _ready():
	connect("state_change", self, "check_neutralized")

func init():
	set_name("Guard")
	unique_name = "First guard"
	base_looking_direction = "left"

func check_neutralized(old_state, new_state):
	print(new_state)
	if new_state == "neutralized":
		fade()

# To override in order to say stuff
#func start_dialog():
#	pass