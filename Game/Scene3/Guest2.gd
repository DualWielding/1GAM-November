extends "res://NPC.gd"

func init():
	set_name(tr("GUEST"))
	unique_name = "Guest two"
	base_looking_direction = "down"

func out():
	walk_left()
	fade()

func enter():
	fade_in()