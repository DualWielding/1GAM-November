extends CanvasLayer

onready var ap = get_node("AnimationPlayer")

func _ready():
	get_node("BackGround").hide()
	get_node("Title").hide()

func show():
	ap.play("Show")
	get_node("BackGround").show()
	get_node("Title").show()
	get_node("ColorFrame").show()

func appear():
	get_node("StreamPlayer").play()
	ap.play("Appear")
	get_node("BackGround").show()
	get_node("Title").show()

func disappear():
	ap.play("Disappear")