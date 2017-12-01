extends "res://NPC.gd"

func init():
	set_name(tr("GUARD"))
	unique_name = "Guard2"
	base_looking_direction = "up"

func enter():
	fade_in()

func out():
	walk_down()
	fade()

func on_state_change(old_state, new_state):
	if new_state == "make alma enter":
		get_parent().make_alma_enter()
	if new_state == "make hero enter":
		get_parent().make_hero_loyalist_enter()