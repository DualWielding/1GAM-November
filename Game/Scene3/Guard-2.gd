extends "res://NPC.gd"

func init():
	set_name(tr("GUARD"))
	unique_name = "Guard2"
	base_looking_direction = "up"

func out():
	walk_down()
	fade()

func enter():
	set_pos(Vector2(555, 575))
	fade_in()