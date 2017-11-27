extends "res://NPC.gd"

func init():
	set_name(tr("THE WAITER"))
	unique_name = "Waiter"
	base_looking_direction = "down"

func enter():
	fade_in()