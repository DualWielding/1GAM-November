extends "res://NPC.gd"

func init():
	set_name(Player.get_name())
	unique_name = "Hero Complotist"
	base_looking_direction = "up"

func enter():
	set_pos(Vector2(546, 562))
	fade_in()
