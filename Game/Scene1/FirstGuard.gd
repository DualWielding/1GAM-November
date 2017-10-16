extends "res://NPC.gd"

func init():
	set_name("Guard")
	unique_name = "First guard"
	base_looking_direction = "left"

# To override in order to say stuff
#func start_dialog():
#	pass