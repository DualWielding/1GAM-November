extends "res://NPC.gd"

func init():
	set_name(tr("GUEST"))
	unique_name = "Guest three"
	base_looking_direction = "right"

func enter():
	fade_in()