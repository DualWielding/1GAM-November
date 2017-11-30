extends "res://NPC.gd"

func init():
	set_name(Player.get_name())
	unique_name = "Hero Plan B"
	base_looking_direction = "up"

func on_state_change(old_state, new_state):
	if new_state == "make alma go":
		get_parent().hero_plan_b_make_alma_go()
	if new_state == "make guards enter":
		get_parent().hero_plan_b_make_guards_enter()

func enter():
	set_pos(Vector2(509, 562))
	fade_in()