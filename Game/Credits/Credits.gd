extends Node2D

onready var persons = get_node("Persons")

func _ready():
	get_node("MainMenu").set_text(tr("MAIN MENU"))
	get_node("MailingList").set_bbcode(str("[url=http://eepurl.com/c6UwPD]", tr("MAILING LIST"), "[/url]"))
	get_node("MailingList").append_bbcode(str("\n[url=www.dual-wielding.com]", tr("WEBSITE"), "[/url]"))
	for child in get_node("Container").get_children():
		child.connect("button_pressed", self, "show_list")
	get_node("ColorFrame/AnimationPlayer").play("fade")

func show_list(name, list):
	persons.clear()
	persons.append_bbcode(str(tr(name.to_upper()),"\n\n"))
	for name in list:
		persons.append_bbcode(str(name, "\n"))

func _on_Persons_meta_clicked( meta ):
	OS.shell_open(meta)

func _on_MailingList_meta_clicked( meta ):
	OS.shell_open(meta)

func _on_Button_pressed():
	persons.clear()
	persons.append_bbcode(tr("END POEM"))


func _on_MainMenu_pressed():
	get_tree().change_scene("res://UI/StartMenu/StartMenu.tscn")
