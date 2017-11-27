extends "res://NPC.gd"

func init():
	set_name(Player.get_name())
	unique_name = "Player character"
	base_looking_direction = "right"

func enter():
	fade_in()