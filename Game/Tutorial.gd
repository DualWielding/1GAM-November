extends Control

var is_on = true

signal got_it

func _ready():
	for child in get_children():
		var cb = child.get_node("CheckBox")
		cb.set_text(tr("TUTORIAL CHECK BOX"))

func show_window(window_name):
	if !is_on:
		emit_signal("got_it")
		return
	
	for child in get_children():
		child.hide()
	
	show()
	
	var window = get_node(window_name)
	window.get_node("Label").set_text(tr(str("TUTORIAL ", window_name.to_upper())))
	window.show()

func hide_window(window_name):
	if !is_on: return
	get_node(window_name).hide()

func _on_Button_pressed():
	hide()
	emit_signal("got_it")

func _on_CheckBox_toggled( pressed ):
	is_on = !pressed
	Player.ui.interaction_button_showed = pressed