extends "res://NPC.gd"

var has_hit = false
var _t = Timer.new()

signal scene_over

func _ready():
	pass

func init():
	add_child(_t)
	set_name("Bandit")
	unique_name = "Bandit"
	base_looking_direction = "right"
	base_speed = 1.2

func _on_InteractionArea_area_enter( area ):
	var body = area.get_parent()
	if body == Player.character and !has_hit:
		has_hit = true
		body.stop_walking()
		stop_walking()
		slash_right()
		animator.connect("finished", Player.character, "collapse", [], CONNECT_ONESHOT)
		animator.connect("finished", get_parent(), "show_title_screen", [], CONNECT_ONESHOT)
		get_parent().title_screen.ap.connect("finished", self, "_flee", [], CONNECT_ONESHOT)
		Player.character.animator.connect("finished", self, "crouch", [], CONNECT_ONESHOT)

func _flee():
	walk_down()
	
	var _t2 = Timer.new()
	_t2.set_wait_time(0.3)
	_t2.set_one_shot(true)
	_t2.connect("timeout", self, "walk_right")
	add_child(_t2)
	_t2.start()
	
	_t.set_wait_time(5.25)
	_t.connect("timeout", self, "_drop_dagger")
	_t.start()
	
	var _t3 = Timer.new()
	_t3.set_wait_time(5.5)
	_t3.set_one_shot(true)
	_t3.connect("timeout", self, "_scene_over")
	add_child(_t3)
	_t3.start()

func _drop_dagger():
	get_parent().dagger.set_pos(get_pos() + Vector2(0, 40))
	get_parent().dagger.show()

func _scene_over():
	fade()
	emit_signal("scene_over")