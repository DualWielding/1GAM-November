extends Node2D


func _ready():
	# Set the player as the duke
	Player.set_name(tr("DUKE"))
	Player.character.sprite.set_texture(load(str("res://Sprites/characters/duke.png")))