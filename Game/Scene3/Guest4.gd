extends "res://NPC.gd"

func init():
	set_name(tr("GUEST"))
	unique_name = "Guest four"
	base_looking_direction = "right"

func out():
	walk_left()
	fade()

func enter():
	fade_in()