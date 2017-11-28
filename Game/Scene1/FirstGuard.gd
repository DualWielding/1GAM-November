extends "res://NPC.gd"

func init():
	set_name(tr("FIRST GUARD"))
	unique_name = "First guard"
	base_looking_direction = "right"

func on_state_change(old_state, new_state):
	if new_state == "neutralized":
		get_parent().get_node("Door").appear()
		fade()