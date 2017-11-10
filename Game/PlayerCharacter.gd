extends "res://Character.gd"

var interaction_possibilities = []

signal can_interact
signal cant_interact

signal disabled
signal enabled

# Player is disabled at the start of the adventure
var disabled_movement = true setget set_disabled_movement, is_disabled

func _ready():
	set_process_input(true)
	Player.character = self

func init():
	base_looking_direction = "left"

func handle_multiple_walking_keys_pressed():
	if Input.is_action_pressed("char_up"):
		walk_up()
	elif Input.is_action_pressed("char_down"):
		walk_down()
	elif Input.is_action_pressed("char_right"):
		walk_right()
	elif Input.is_action_pressed("char_left"):
		walk_left()
	else:
		stop_walking()

func _input(event):
	if is_disabled():
		return
	
	if event.is_action_pressed("char_up"):
		walk_up()
	elif event.is_action_pressed("char_down"):
		walk_down()
	elif event.is_action_pressed("char_right"):
		walk_right()
	elif event.is_action_pressed("char_left"):
		walk_left()
	
	if event.is_action_released("char_left")\
	or event.is_action_released("char_right")\
	or event.is_action_released("char_up")\
	or event.is_action_released("char_down"):
		handle_multiple_walking_keys_pressed()

######## HURT ########

func collapse():
	animator.play("Hurt")
	set_disabled_movement(true)

func stand_up():
	animator.play_backwards("Hurt")
	animator.connect("finished", self, "set_disable_movement", [false], CONNECT_ONESHOT)

######## MOVEMENT ########

func set_disabled_movement(boolean):
	if boolean:
		emit_signal("disabled")
		stop_walking()
	else:
		emit_signal("enabled")
	disabled_movement = boolean

func is_disabled():
	return disabled_movement

###### INTERACTIONS ######

func add_interaction_possibility(body):
	if interaction_possibilities.size() == 0:
		emit_signal("can_interact")
	interaction_possibilities.append(body)

func remove_interaction_possibility(body):
	interaction_possibilities.remove(interaction_possibilities.find(body))
	if interaction_possibilities.size() == 0:
		emit_signal("cant_interact")

func _on_InteractionArea_area_enter( area ):
	var body = area.get_parent()
	if interaction_possibilities.find(body) == -1:
		add_interaction_possibility(body)

func _on_InteractionArea_area_exit( area ):
	var body = area.get_parent()
	remove_interaction_possibility(body)






func get_name():
	return Player.get_name()