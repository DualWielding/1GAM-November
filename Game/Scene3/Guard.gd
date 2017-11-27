extends "res://NPC.gd"

func init():
	set_name(tr("GUARD"))
	unique_name = "Second guard"
	base_looking_direction = "right"

func enter():
	fade_in()