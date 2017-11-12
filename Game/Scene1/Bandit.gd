extends "res://NPC.gd"

var _t = Timer.new()

signal scene_over

func init():
	add_child(_t)
	set_name("Bandit")
	unique_name = "Bandit"
	base_looking_direction = "left"

func _on_InteractionArea_area_enter( area ):
	var body = area.get_parent()
	if body == Player.character:
		stop_walking()
		slash_left()
		animator.connect("finished", Player.character, "collapse", [], CONNECT_ONESHOT)
		animator.connect("finished", get_parent(), "show_title_screen", [], CONNECT_ONESHOT)
		Player.character.animator.connect("finished", self, "crouch", [], CONNECT_ONESHOT)

func _flee(dagger_dropped):
	Player.ui.dialog_panel.hide_panel()
	walk_right()
	_t.set_wait_time(2.5)
	_t.set_one_shot(true)
	_t.disconnect("timeout", self, "_flee")
	
	if !dagger_dropped:
		_t.connect("timeout", self, "_drop_dagger")
	else:
		_t.connect("timeout", self, "_scene_over")
	
	_t.start()

func _drop_dagger():
#	stop_walking()
#	crouch()
	get_parent().dagger.set_pos(get_pos() + Vector2(0, 40))
	get_parent().dagger.show()
	_t.set_wait_time(0.3)
	_t.set_one_shot(true)
	_t.disconnect("timeout", self, "_drop_dagger")
	_t.connect("timeout", self, "_flee", [true])
	_t.start()

func _scene_over():
	fade()
	emit_signal("scene_over")