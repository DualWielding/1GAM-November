extends "res://NPC.gd"

func init():
	set_name("Strozi")
	unique_name = "Strozi"
	base_looking_direction = "right"

func enter():
	fade_in()