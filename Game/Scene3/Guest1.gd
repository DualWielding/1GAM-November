extends "res://NPC.gd"

func init():
	set_name(tr("GUEST"))
	unique_name = "Guest"
	base_looking_direction = "down"

func out():
	walk_right()
	fade()

func on_state_change(old_state, new_state):
	if new_state == "make duke monologing":
		get_parent().start_duke_monolog()

func stop_dialog(option):
	Player.character.set_disabled_movement(false)
	emit_signal("stop_dialog")
	get_parent().guests_leave()
	get_parent().duke_goes_to_firework()