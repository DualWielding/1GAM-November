extends Node2D

onready var vitori = get_node("Vitori-2")
onready var giulia = get_node("Giulia")
onready var philippe = get_node("Sire Philippe")
onready var ruffio = get_node("Ruffio")
onready var waiter = get_node("Waiter")
onready var alma = get_node("Alma")
onready var augurie = get_node("Augurie")
onready var claudio = get_node("Claudio")
onready var strozi = get_node("Strozi")

onready var scene_timer = get_node("SceneTimer")
onready var sp = get_node("SamplePlayer")

func state_change_controller(old_state, new_state, character):
	if character.get_name() == "Ruffio" and new_state == "has_yelled":
		everyone_enter()

func _ready():
	Player.character.look_at("up")
	ruffio.look_at("up")
	Player.character.set_disabled_movement(true)
	Player.character.hide()
	ruffio.hide()
	Player.ui.show_book()
	Player.ui.dialog_panel.ap.connect("finished", self, "write_scene_informations", [], CONNECT_ONESHOT)

func get_step_type(pos):
	return ["stepstone_", 8]

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

func everyone_enter():
	vitori.enter()
	alma.enter()
	philippe.enter()
	giulia.enter()
	claudio.enter()
	augurie.enter()
	waiter.enter()
	strozi.enter()
	sp.play("ambiance_soiree")
	get_node("StreamPlayer").play()

func next_scene():
	get_node("SamplePlayer").play("ouverture_porte_2")
	var t = Timer.new()
	t.set_wait_time(0.7)
	t.connect("timeout", self, "change_scene")
	add_child(t)
	t.start()

func start_music():
	get_node("StreamPlayer").play()

func set_music_volume():
	pass

func change_scene():
	get_tree().change_scene("res://Scene3/Scene3.tscn")