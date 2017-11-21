extends Node2D

onready var vitori = get_node("Vitori-2")
onready var giulia = get_node("Giulia")
onready var philippe = get_node("Sire Philippe")
onready var ruffio = get_node("Ruffio")
onready var waiter = get_node("Waiter")
onready var alma = get_node("Alma")
onready var augurie = get_node("Augurie")
onready var claudio = get_node("Claudio")

func start():
	Player.ui.show_book()
	Player.ui.dialog_panel.ap.connect("finished", self, "write_scene_informations", [], CONNECT_ONESHOT)

func write_scene_informations():
	Player.ui.dialog_panel.add_text(tr("SCENE 2 INTRO"), "fade", true)
	
	var container = Player.ui.dialog_panel.script_container
	var last_child = container.get_children()[container.get_child_count() - 1]
	last_child.get_children()[0].connect("finished", self, "start_playing", [], CONNECT_ONESHOT)

func start_playing():
	ruffio.fade_in()