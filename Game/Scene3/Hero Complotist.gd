extends "res://NPC.gd"

func init():
	set_name(Player.get_name())
	unique_name = "Hero Complotist"
	base_looking_direction = "up"

func start_dialog():
	if state == "default":
		get_parent().hero_complotist_stabs_duke()
	
	# Stop the player's movement while interacting
	Player.character.set_disabled_movement(true)
	
	# Turn to the player
	var p_pos = Player.character.get_pos()
	var pos = get_pos()
	var dif_x = p_pos.x - pos.x
	var dif_y = p_pos.y - pos.y
	var dir
	
	if abs(dif_x) > abs(dif_y):
		if dif_x < 0:
			dir = "left"
		else:
			dir = "right"
	else:
		if dif_y < 0:
			dir = "up"
		else:
			dir = "down"
	
	look_at(dir)
	
	
	say(tr(sequences[state]["text"]), sequences[state]["options"])
	
	Player.ui.dialog_panel.disable_toggling()

func stop_dialog(option):
	# Re-enable the character movement
	if state == "make hero final monolog 3":
		get_parent().hero_complotist_die()
		get_parent().the_end()
		return
	
	Player.character.set_disabled_movement(false)
	
	look_at(base_looking_direction)
	
	if option["state change"] != "unchanged":
		state = option["state change"]
	emit_signal("stop_dialog")
	
	Player.ui.dialog_panel.enable_toggling()

func on_state_change(old_state, new_state):
	if new_state == "make hero final monolog":
		get_parent().hero_complotist_final_monolog()
	elif new_state == "make hero final monolog 2":
		get_parent().hero_complotist_final_monolog2()
	elif new_state == "make hero final monolog 3":
		get_parent().hero_complotist_final_monolog3()
	elif new_state == "stabs_duke":
		get_parent().hero_complotist_stabs_duke()
	elif new_state == "kissing":
		get_parent().hero_complotist_kisses()

func enter():
	set_pos(Vector2(575, 580))
	fade_in()
