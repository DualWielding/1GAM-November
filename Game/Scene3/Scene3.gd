extends Node2D

onready var guest = get_node("Guest1")
onready var alma = get_node("Alma-2")
onready var hero = get_node("Hero")
onready var guard = get_node("Guard")

func _ready():
	# Set the player as the duke
	Player.display_name = tr("DUKE")
#	Player.character.sprite.set_texture(load(str("res://Sprites/characters/duke.png"))) # TODO activate that
	start_music() #TODO activate that
	Player.character.look_at("up")
	Player.character.set_disabled_movement(true)
	Player.character.show()
	Player.ui.show_book()
	Player.ui.dialog_panel.ap.connect("finished", self, "write_scene_informations", [], CONNECT_ONESHOT)

func write_scene_informations():
	Player.ui.dialog_panel.add_text(tr("SCENE 3 INTRO"), "fade", true)
	
	var container = Player.ui.dialog_panel.script_container
	var last_child = container.get_children()[container.get_child_count() - 1]
	last_child.get_children()[0].connect("finished", self, "start_playing", [], CONNECT_ONESHOT)

func start_playing():
	guest.start_dialog()

########## DUKE ############

func start_duke_monolog():
	var t = get_timer(0.4)
	t.connect("timeout", Player.character, "stop_walking")
	t.start()
	Player.character.walk_down()

func duke_goes_to_firework():
	Player.character.set_disabled_movement(true)
	# triggered by guest 1
	var t1 = get_timer(1.8)
	var t2 = get_timer(0.4)
	var t3 = get_timer(1.8)
	
	Player.character.walk_left()
	t1.connect("timeout", Player.character, "walk_down")
	t1.connect("timeout", t2, "start")
	t1.start()
	t2.connect("timeout", Player.character, "walk_left")
	t2.connect("timeout", t3, "start")
	t3.connect("timeout", Player.character, "stop_walking")
	t3.connect("timeout", self, "guard_enter")

########## GUARD ENTER ################

func guard_enter():
	guard.fade_in()
	guard.walk_up()
	var t1 = get_timer(1.5)
	t1.connect("timeout", self, "start_guard_conversation")
	t1.start()

func start_guard_conversation():
	guard.stop_walking()
	guard.start_dialog()

########## GUESTS ################

func guests_leave():
# triggered by guest 1
	for i in range(5):
		get_node(str("Guest", i+1)).fade()


######### TECH ###########

func get_timer(wait_time, one_shot=true):
	var t = Timer.new()
	t.set_wait_time(wait_time)
	t.set_one_shot(one_shot)
	add_child(t)
	return t

func get_step_type(pos):
	return ["stepwood_", 2]

func start_music():
	get_node("StreamPlayer").play()

func set_music_volume():
	pass