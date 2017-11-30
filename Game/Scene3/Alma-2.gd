extends "res://NPC.gd"

func init():
	set_name("Alma")
	unique_name = "Alma2"
	base_looking_direction = "up"

func enter():
	fade_in()

func on_state_change(old_state, new_state):
	if new_state == "make hero enter":
		get_parent().make_hero_plan_b_enter()