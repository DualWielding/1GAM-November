extends Node2D

onready var ap = get_node("AnimationPlayer")
onready var sprite = get_node("Sprite")

var options = {}
var text

signal button_pressed(name, list)

func _ready():
	add_to_group("credit_char")
	sprite.set_frame(32)
	
	var path = str("res://Credits/", get_name(), ".json")
	var file = File.new()
	
	if !file.file_exists(path):
		print("Soz, but Credit json file does not exist.")
		return
	
	
	file.open(path, file.READ)
	var t = file.get_as_text()
	options.parse_json(t)
	file.close()
	
	if file.file_exists(str("res://Sprites/characters/", options.char ,".png")):
		sprite.set_texture(load(str("res://Sprites/characters/", options.char,".png")))
	
	get_node("Button").set_tooltip(get_name())


func start_walking():
	get_node("AnimationPlayer").play("Walk_down")

func stop_walking():
	get_node("AnimationPlayer").stop_all()
	get_node("Sprite").set_frame(130)

func _on_Button_pressed():
	emit_signal("button_pressed", get_name(), options.list)

func _on_Button_mouse_enter():
	ap.play("salute")

func _on_Button_mouse_exit():
	ap.stop_all()
	sprite.set_frame(32)
