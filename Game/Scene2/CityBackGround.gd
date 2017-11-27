extends TileMap

var dif = 0

func _ready():
	set_process(true)

func _process(delta):
	if Player.character.get_pos().y <= OS.get_window_size().y * 0.66:
		if dif == 0:
			dif = get_pos().y - Player.character.get_pos().y
		set_pos(Vector2(get_pos().x, Player.character.get_pos().y + dif))