extends Node2D

onready var vitori = get_node("Vitori-2")
onready var giulia = get_node("Giulia")
onready var philippe = get_node("Sire Philippe")
onready var ruffio = get_node("Ruffio")
onready var waiter = get_node("Waiter")
onready var alma = get_node("Alma")
onready var augurie = get_node("Augurie")
onready var claudio = get_node("Claudio")

onready var scene_timer = get_node("SceneTimer")

func state_change_controller(old_state, new_state, character):
	if character.get_name() == "Ruffio" and new_state == "has_yelled":
		eneveryone_enter()

func _ready():
	Player.character.look_at("up")
	ruffio.look_at("up")
	Player.character.set_disabled_movement(true)
	Player.character.hide()
	ruffio.hide()
	Player.ui.show_book()
	Player.ui.dialog_panel.ap.connect("finished", self, "write_scene_informations", [], CONNECT_ONESHOT)

func write_scene_informations():
	Player.ui.dialog_panel.add_text(tr("SCENE 2 INTRO"), "fade", true)
	
	var container = Player.ui.dialog_panel.script_container
	var last_child = container.get_children()[container.get_child_count() - 1]
	last_child.get_children()[0].connect("finished", self, "start_playing", [], CONNECT_ONESHOT)

func start_playing():
	ruffio.fade_in()
	ruffio.walk_up()
	var t = Timer.new()
	add_child(t)
	t.set_wait_time(0.09)
	t.connect("timeout", Player.character, "walk_up", [], CONNECT_ONESHOT)
	t.connect("timeout", Player.character, "fade_in", [], CONNECT_ONESHOT)
	t.connect("timeout", t, "queue_free")
	t.start()
	
	scene_timer.set_wait_time(0.6)
	scene_timer.set_one_shot(true)
	scene_timer.connect("timeout", self, "start_ruffio_dialog", [], CONNECT_ONESHOT)
	scene_timer.start()

func start_ruffio_dialog():
	Player.character.stop_walking()
	Player.character.look_at("left")
	ruffio.stop_walking()
	ruffio.start_dialog()
	ruffio.connect("state_change", self, "state_change_controller", [ruffio], CONNECT_ONESHOT)

func eneveryone_enter():
	Player.ui.dialog_panel.add_text(tr("SCENE 2 EVERYONE ENTER"), "fade", true)
	vitori.enter()
	alma.enter()
	philippe.enter()
	giulia.enter()
	claudio.enter()
	augurie.enter()
	waiter.enter()