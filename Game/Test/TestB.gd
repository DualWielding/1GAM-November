extends Control

func _ready():
	print("lolz")
	get_parent().get_node("Test").connect("sent", self, "catch")
	get_parent().get_node("Test").start()

func catch(data):
	print("catched data !")
	print(data)