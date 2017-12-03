extends Control

func _ready():
	TranslationServer.set_locale("fr")
	set_buttons_text()

func set_buttons_text():
	get_node("Start").set_text(tr("START BUTTON"))
	get_node("Quit").set_text(tr("QUIT BUTTON"))
	Player.name = tr("STARTING PLAYER NAME")
	Player.display_name = tr("STARTING PLAYER NAME")

func _on_Fr_pressed():
	TranslationServer.set_locale("fr")
	set_buttons_text()

func _on_En_pressed():
	TranslationServer.set_locale("en")
	set_buttons_text()

func _on_Start_pressed():
	get_node("Loading").set_text(tr("LOADING"))
	var t = Timer.new()
	add_child(t)
	t.set_wait_time(0.1)
	t.set_one_shot(true)
	t.connect("timeout", self, "change_scene")
	t.start()

func change_scene():
	Cards.load_cards()
	get_tree().change_scene("res://Scene1/Scene1.tscn")


func _on_Quit_pressed():
	get_tree().quit()