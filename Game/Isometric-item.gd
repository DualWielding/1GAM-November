extends Node2D

var in_it = false
var body = null

var can_be_interacted_with = false

export var ceil_value = 10 # the one for the lamp

func _ready():
	set_process(true)

func _process(delta):
	if in_it:
		var y = body.get_pos().y - get_pos().y
		if get_z() == 0 and y < ceil_value:
			set_z(1)
		elif get_z() == 1 and y >= ceil_value:
			set_z(0)

func _on_PlayerDetectionArea_area_enter( area ):
	if area.get_parent() == Player.character:
		body = area.get_parent()
		in_it = true

func _on_PlayerDetectionArea_area_exit( area ):
	if area.get_parent() == Player.character:
		body = null
		in_it = false