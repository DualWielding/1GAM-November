extends "res://NPC.gd"

func init():
	set_name("Alma")
	unique_name = "Alma"
	base_looking_direction = "right"

func enter():
	fade_in()