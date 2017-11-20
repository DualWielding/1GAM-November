extends "res://Body.gd"

onready var sprite = get_node("Sprite")
onready var lo_face = get_node("LightOccluderFace")
onready var lo_left = get_node("LightOccluderLeft")
onready var lo_right = get_node("LightOccluderRight")
onready var animator = get_node("AnimationPlayer")

var current_direction = null
var base_looking_direction = "left"
var base_speed = 1.0

func _ready():
	is_object = false
	var file = File.new()
	if file.file_exists(str("res://Sprites/characters/", unique_name,".png")):
		sprite.set_texture(load(str("res://Sprites/characters/", unique_name,".png")))
	add_to_group("character")
	set_fixed_process(true)
	look_at(base_looking_direction)

func _fixed_process(delta):
	if current_direction == "up":
		move(Vector2(0, -100) * delta * base_speed)
	elif current_direction == "down":
		move(Vector2(0, 100) * delta * base_speed)
	elif current_direction == "right":
		move(Vector2(100, 0) * delta * base_speed)
	elif current_direction == "left":
		move(Vector2(-100, 0) * delta * base_speed)

######## HURT ########

func collapse():
	animator.play("Hurt")

func stand_up():
	animator.play_backward("Hurt")

######## WALKING ########

func walk_up():
	current_direction  = "up"
	animator.play("Walk_up")

func walk_down():
	current_direction = "down"
	animator.play("Walk_down")

func walk_left():
	current_direction = "left"
	animator.play("Walk_left")

func walk_right():
	current_direction = "right"
	animator.play("Walk_right")

func stop_walking():
	if current_direction == null:
		return
	
	var f = funcref(self, "set_stand_to_base_" + current_direction)
	f.call_func()
	current_direction = null
	animator.stop_all()

######## HITTING ########

func slash_left():
	animator.play("Slash_left")

func slash_right():
	animator.play("Slash_right")


######## STANDING ########

func set_stand_sprites():
	sprite.show()

func set_stand_to_base_up():
	set_stand_sprites()
	lo_face.show()
	lo_left.hide()
	lo_right.hide()
	sprite.set_frame(104)

func set_stand_to_base_left():
	set_stand_sprites()
	lo_face.hide()
	lo_left.show()
	lo_right.hide()
	sprite.set_frame(117)

func set_stand_to_base_down():
	set_stand_sprites()
	lo_face.show()
	lo_left.hide()
	lo_right.hide()
	sprite.set_frame(130)

func set_stand_to_base_right():
	set_stand_sprites()
	lo_face.hide()
	lo_left.hide()
	lo_right.show()
	sprite.set_frame(143)

func look_at(direction):
	if direction == "up":
		set_stand_to_base_up()
	elif direction == "right":
		set_stand_to_base_right()
	elif direction == "left":
		set_stand_to_base_left()
	elif direction == "down":
		set_stand_to_base_down()

func crouch():
	sprite.set_frame(262)