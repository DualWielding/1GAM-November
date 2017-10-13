extends "res://NPC.gd"

func _ready():
	walk_right()

func init():
	set_name("Unknown")
	unique_name = "First Unknown"
	base_looking_direction = "right"

# To override in order to say stuff
#func start_dialog():
#	pass

# Override the base stop_dialog function
# In order to prevent the player from moving
func stop_dialog(option):
	emit_signal("stop_dialog")
	
	if option["state change"] != "unchanged":
		state = option["state change"]
	
	walk_left()
	fade()

func fade():
	get_node("FadePlayer").play("Fade")
	get_node("FadePlayer").connect("finished", self, "end_scene")

func end_scene():
	Player.character.set_disabled_movement(false)
	queue_free()

func _on_InteractionArea_area_enter( area ):
	var body = area.get_parent()
	if body == Player.character:
		stop_walking()
		start_dialog()