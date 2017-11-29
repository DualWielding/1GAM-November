extends Node2D

func _ready():
	# Set the player as the duke
#	Player.set_name(tr("DUKE"))
#	Player.character.sprite.set_texture(load(str("res://Sprites/characters/duke.png")))
	Player.character.set_disabled_movement(false)
	Player.character.show()
	
	start_music()

func get_step_type(pos):
	return ["stepwood_", 2]

func start_music():
	get_node("StreamPlayer").play()

func set_music_volume():
	pass