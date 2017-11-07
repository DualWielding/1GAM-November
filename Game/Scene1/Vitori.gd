extends "res://NPC.gd"

func start():
	walk_right()

func init():
	set_name("Vitori")
	unique_name = "Vitori"
	base_looking_direction = "right"

# Override the base stop_dialog function
# In order to prevent the player from moving
func stop_dialog(option):
	Player.character.set_disabled_movement(false)
	emit_signal("stop_dialog")
	walk_left()
	fade()

func fade():
	get_node("FadePlayer").play("Fade")
	get_node("FadePlayer").connect("finished", self, "end_scene")

func end_scene():
	queue_free()

func _on_InteractionArea_area_enter( area ):
	var body = area.get_parent()
	if body == Player.character:
		stop_walking()
		start_dialog()
		Player.character.stand_up()