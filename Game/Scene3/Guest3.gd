extends "res://NPC.gd"

func init():
	set_name(tr("GUEST"))
	unique_name = "Guest three"
	base_looking_direction = "up"

func enter():
	fade_in()