extends Node2D

onready var guest = get_node("Guest1")
onready var alma = get_node("Alma-2")
onready var alma2 = get_node("Alma-3")
onready var hero_loyalist = get_node("Hero Loyalist")
onready var hero_plan_b = get_node("Hero Plan B")
onready var hero_complotist = get_node("Hero Complotist")
onready var guard = get_node("Guard")
onready var guard2 = get_node("Guard-2")
onready var sir_p = get_node("Sire Philippe-2")

func _ready():
	# Set the player as the duke
	Player.character.set_disabled_movement(true)
	Player.display_name = tr("DUKE")
#	Player.character.sprite.set_texture(load(str("res://Sprites/characters/duke.png"))) # TODO activate that
#	start_music() #TODO activate that
	Player.character.look_at("up")
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
	var t1 = get_timer(1.0)
	t1.connect("timeout", self, "start_guard_conversation")
	t1.start()

func start_guard_conversation():
	Player.character.look_at("down")
	guard.stop_walking()
	guard.start_dialog()

########## ALMA #################

func make_alma_enter():
	guard.out()
	alma.fade_in()
	alma.walk_up()
	var t1 = get_timer(1.4)
	t1.connect("timeout", self, "start_alma_dialog")
	t1.start()

func start_alma_dialog():
	alma.stop_walking()
	alma.look_at("right")
	Player.character.look_at("left")
	alma.start_dialog()

########## HERO LOYALIST #################

func make_hero_loyalist_enter():
	pass

########## HERO COMPLOTIST ##############

func make_hero_complotist_enter():
	pass

########## HERO PLAN B ############

func make_hero_plan_b_enter():
	Player.character.collapse()
	Player.character.animator.connect("finished", self, "hero_plan_b_start_dialog")

func hero_plan_b_start_dialog():
	alma.look_at("down")
	hero_plan_b.enter()
	hero_plan_b.start_dialog()

func hero_plan_b_make_alma_go():
	alma.out()
	hero_plan_b.walk_up()
	var t1 = get_timer(1.35)
	t1.connect("timeout", self, "hero_plan_b_search_duke")
	t1.start()

func hero_plan_b_search_duke():
	hero_plan_b.stop_walking()
	hero_plan_b.crouch()

func hero_plan_b_make_guards_enter():
	sir_p.enter()
	alma2.enter()
	guard2.enter()
	sir_p.start_dialog()

########## GUESTS ################

func guests_leave():
# triggered by guest 1
	for i in range(5):
		get_node(str("Guest", i+1)).out()


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