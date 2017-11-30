extends "res://NPC.gd"

func init():
	set_name(tr("SIR PHILIPPE"))
	unique_name = "Sire Philippe2"
	base_looking_direction = "up"

func enter():
	set_pos(Vector2(505, 550))
	fade_in()