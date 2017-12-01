extends "res://NPC.gd"

func init():
	set_name(tr("SIR PHILIPPE"))
	unique_name = "Sire Philippe2"
	base_looking_direction = "up"

func out():
	walk_down()
	fade()

func enter():
	set_pos(Vector2(510, 550))
	fade_in()

func on_state_change(old_state, new_state):
	if new_state == "make guard attack hero":
		get_parent().make_guard_attack_hero()