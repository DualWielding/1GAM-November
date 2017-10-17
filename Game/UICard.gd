extends Control

var name = "Test"
var unique_name = "Test"
var text = "Test"
var img = preload("res://Sprites/Floor.png")

func init_from_dic(dic):
	name = tr(dic.unique_name)
	text = dic.text
	img = dic.img
	unique_name = dic.unique_name

func _ready():
	get_node("VirginCard/Name").set_text(name)
	get_node("VirginCard/Picture").set_texture(img)
	get_node("VirginCard/Text").set_text(text)