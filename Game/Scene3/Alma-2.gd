extends "res://NPC.gd"

func init():
	set_name("Alma")
	unique_name = "Alma2"
	base_looking_direction = "up"

func out():
	walk_left()
	fade()

func enter():
	fade_in()

func stop_dialog(option):
	if state == "hero approach4":
		get_parent().duke_faces_off()
	
	# Re-enable the character movement
	Player.character.set_disabled_movement(false)
	
	look_at(base_looking_direction)
	
	if option["state change"] != "unchanged":
		state = option["state change"]
	emit_signal("stop_dialog")
	
	Player.ui.dialog_panel.enable_toggling()

func on_state_change(old_state, new_state):
	if new_state == "make hero enter":
		get_parent().make_hero_plan_b_enter()
	elif new_state == "hero approach1":
		get_parent().make_hero_complotist_enter()
	elif new_state.begins_with("hero approach"):
		get_parent().hero_approach()