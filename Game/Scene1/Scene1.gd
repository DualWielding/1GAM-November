extends Node2D

onready var vitori = get_node("Vitori")
onready var bandit = get_node("Bandit")
onready var player = get_node("PlayerCharacter")
onready var dagger = get_node("Dagger")

onready var title_screen = get_node("TitleScreen")

func _ready():
	bandit.connect("scene_over", self, "intro_pause", [], CONNECT_ONESHOT)
	bandit.walk_left()

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
	vitori.get_node("FadePlayer").play_backwards("Fade")
	vitori.show()
	vitori.walk_right()

func show_title_screen():
	title_screen.show()
	title_screen.ap.connect("finished", bandit, "_flee", [false], CONNECT_ONESHOT)