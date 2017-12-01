extends "res://NPC.gd"

func init():
	set_name(Player.get_name())
	unique_name = "Hero Loyalist"
	base_looking_direction = "up"

func stop_dialog(option):
	# Re-enable the character movement
	if state == "make hero go to table":
		get_parent().hero_loyalist_die()
		get_parent().the_end()
		return
	
	Player.character.set_disabled_movement(false)
	
	look_at(base_looking_direction)
	
	if option["state change"] != "unchanged":
		state = option["state change"]
	emit_signal("stop_dialog")
	
	Player.ui.dialog_panel.enable_toggling()

func on_state_change(old_state, new_state):
	if new_state == "make the duke come to him":
		get_parent().hero_loyalist_collapses()
	elif new_state == "make the duke go out":
		get_parent().hero_loyalist_duke_out()
	elif new_state == "make hero go to table":
		get_parent().hero_loyalist_go_to_table()

func enter():
	set_pos(Vector2(546, 562))
	fade_in()