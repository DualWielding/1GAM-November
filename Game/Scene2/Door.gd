extends "res://Body.gd"

func init():
	set_name(tr("DOOR"))
	unique_name = "SCENE 2 DOOR"

func start_dialog():
	if Player.has_card("DIVERSION") and (Player.has_card("LOYALIST QUEST") or Player.has_card("COMPLOTIST QUEST")):
		get_parent().next_scene()
	else:
		# Stop the player's movement while interacting
		Player.character.set_disabled_movement(true)
		
		say(tr(sequences[state]["text"]), sequences[state]["options"])
		
		Player.ui.dialog_panel.disable_toggling()