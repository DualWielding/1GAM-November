extends "res://NPC.gd"

func init():
	set_name("Alma")
	unique_name = "Alma2"
	base_looking_direction = "up"

func out():
	walk_down()
	fade()

func enter():
	set_pos(Vector2(465, 575))
	fade_in()