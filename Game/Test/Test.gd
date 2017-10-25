extends Node

var b = { "blbl": "lol", "bl": true}
var a = { "blbl": "l", "bl": false}
var c = {"blbl": "a"}

signal sent(data)

func _ready():
	print("lilz")

func start():
	print("started")
	send(a)
	send(b)
	send(b)

func send(data):
	emit_signal("sent", data)