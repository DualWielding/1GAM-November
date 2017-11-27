extends TileMap

var in_it = false
var body = null

var can_be_interacted_with = false

export var ceil_value = 10 # the one for the lamp

func _ready():
	set_process(true)

func _process(delta):
	if in_it:
		var y = body.get_pos().y - get_pos().y
		var x = body.get_pos().x - get_pos().x
		if x > 459 and x < 665:
			if y >= 534:
				set_z(0)
			else:
				set_z(1)
		else:
			if y > 471:
				set_z(0)
			else:
				set_z(1)

func _on_PlayerDetectionArea_area_enter( area ):
	if area.get_parent() == Player.character:
		body = area.get_parent()
		in_it = true

func _on_PlayerDetectionArea_area_exit( area ):
	if area.get_parent() == Player.character:
		body = null
		in_it = false