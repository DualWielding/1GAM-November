extends "res://NPC.gd"

func init():
	set_name("Claudio")
	unique_name = "Claudio"
	base_looking_direction = "left"

func enter():
	fade_in()