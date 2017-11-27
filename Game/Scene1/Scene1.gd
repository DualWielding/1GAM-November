extends Node2D

onready var vitori = get_node("Vitori")
onready var bandit = get_node("Bandit")
onready var player = get_node("PlayerCharacter")
onready var dagger = get_node("Dagger")

onready var title_screen = get_node("TitleScreen")

func _ready():
	Player.ui.show_book()
	Player.ui.tutorial.connect("got_it", self, "explain_cards", [], CONNECT_ONESHOT)
	Player.ui.dialog_panel.ap.connect("finished", Player.ui.tutorial, "show_window", ["Book"], CONNECT_ONESHOT)
	Player.ui.dialog_panel.ap.connect("finished", self, "write_scene_informations", [], CONNECT_ONESHOT)

func get_step_type(pos):
	if pos.y < 460:
		return ["stepstone_", 8]
	else:
		if pos.x > 450 and pos.x < 705 and pos.y < 520:
			return ["stepstone_", 8]
		else:
			return ["stepdirt_", 8]

func write_scene_informations():
	Player.ui.dialog_panel.add_text(tr("SCENE 1 INTRO"), "fade", true)

func explain_cards():
	Player.ui.tutorial.disconnect("got_it", self, "explain_cards")
	Player.ui.tutorial.connect("got_it", self, "start_playing", [], CONNECT_ONESHOT)
	Player.ui.tutorial.show_window("Cards")

func start_playing():
	Player.ui.hide()
	Player.ui.hide_dialog()
	bandit.fade_in()
	bandit.show()
	player.walk_right()
	bandit.connect("scene_over", self, "intro_pause", [], CONNECT_ONESHOT)
	bandit.walk_right()

func intro_pause():
	Player.ui.show()
	var t = Timer.new()
	t.set_wait_time(0.7)
	add_child(t)
	t.set_one_shot(true)
	t.connect("timeout", self, "start_vitoris_scene")
	t.connect("timeout", t, "queue_free")
	t.start()

func start_vitoris_scene():
	Player.ui.dialog_panel.add_text(tr("SCENE 1 ENTERS VITORI"), "fade", true)
	vitori.get_node("FadePlayer").play_backwards("Fade")
	vitori.show()
	vitori.walk_right()

func show_title_screen():
	title_screen.show()

func next_scene():
	get_node("SamplePlayer").play("ouverture_porte_2")
	var t = Timer.new()
	t.set_wait_time(0.7)
	t.connect("timeout", self, "change_scene")
	add_child(t)
	t.start()

func change_scene():
	get_tree().change_scene("res://Scene2/Scene2.tscn")