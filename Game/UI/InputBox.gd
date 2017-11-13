extends VBoxContainer

onready var text_edit = get_node("LineEdit")
onready var button = get_node("Button")

func _ready():
	var hotkey = InputEvent()
	hotkey.type = InputEvent.KEY
	hotkey.scancode = KEY_ENTER
	var sc = ShortCut.new()
	sc.set_shortcut(hotkey)
	button.set_shortcut(sc)