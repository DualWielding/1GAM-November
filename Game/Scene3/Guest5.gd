extends "res://NPC.gd"

func init():
	set_name(tr("GUEST"))
	unique_name = "Guest five"
	base_looking_direction = "up"

func out():
	walk_left()
	fade()

func enter():
	fade_in()