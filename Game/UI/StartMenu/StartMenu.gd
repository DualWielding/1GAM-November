extends Control

func _ready():
	set_buttons_text()

func set_buttons_text():
	get_node("Start").set_text(tr("START BUTTON"))
	get_node("Quit").set_text(tr("QUIT BUTTON"))

func _on_Fr_pressed():
	TranslationServer.set_locale("fr")
	set_buttons_text()

func _on_En_pressed():
	TranslationServer.set_locale("en")
	set_buttons_text()

func _on_Start_pressed():
	get_tree().change_scene("res://Scene1/Scene1.tscn")


func _on_Quit_pressed():
	get_tree().quit()