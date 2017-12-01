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
	Player.character.sprite.set_texture(load(str("res://Sprites/characters/duke.png")))
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

func hero_approach():
	var t = get_timer(0.36)
	hero_complotist.walk_up()
	t.connect("timeout", hero_complotist, "stop_walking")
	t.start()

func duke_faces_off():
	Player.character.look_at("right")
	var t = get_timer(1)
	t.connect("timeout", hero_complotist, "start_dialog")
	t.start()

########## HERO LOYALIST #################

func make_hero_loyalist_enter():
	pass

########## HERO COMPLOTIST ##############

func make_hero_complotist_enter():
	hero_complotist.enter()
	hero_approach()

func hero_complotist_stabs_duke():
	hero_complotist.look_at("left")
	hero_complotist.slash_left()
	hero_complotist.animator.connect("finished", Player.character, "collapse", [], CONNECT_ONESHOT)
	hero_complotist.animator.connect("finished", hero_complotist, "look_at", ["left"], CONNECT_ONESHOT)
	alma.out()

func hero_complotist_kisses():
	hero_complotist.crouch()

func hero_complotist_final_monolog():
	hero_complotist.base_speed = 0.5
	hero_complotist.walk_up(0.5)
	var t1 = get_timer(2)
	t1.connect("timeout", hero_complotist, "stop_walking")
	t1.start()

func hero_complotist_final_monolog2():
	hero_complotist.stop_walking()
	hero_complotist.look_at("down")
	var t1 = get_timer(0.2)
	t1.connect("timeout", hero_complotist, "hero_complotist_falters")
	t1.start()

func hero_complotist_falters():
	hero_complotist.base_speed = 0.3
	hero_complotist.walk_down(0.3)

func hero_complotist_final_monolog3():
	hero_complotist.stop_walking()
	hero_complotist.crouch()

func hero_complotist_die():
	hero_complotist.collapse()

########## HERO PLAN B ############

func make_hero_plan_b_enter():
	Player.character.collapse()
	var t = get_timer(1.5)
	t.connect("timeout", self, "hero_plan_b_start_dialog")
	t.start()

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
	hero_plan_b.look_at("down")
	var t = get_timer(1.5)
	t.connect("timeout", sir_p, "start_dialog")
	t.start()

func hero_plan_b_make_guards_out():
	Player.character.crouch()
	sir_p.out()
	alma2.out()
	guard2.out()

########## Sir Philippe ##########

func make_guard_attack_hero():
	guard2.base_speed = 1.3
	guard2.walk_up()
	var t1 = get_timer(0.85)
	t1.connect("timeout", guard2, "walk_left")
	t1.start()
	var t2 = get_timer(1.2)
	t2.start()
	t2.connect("timeout", self, "guard_attack")

func guard_attack():
	guard2.stop_walking()
	guard2.thrust_up()
	guard2.animator.connect("finished", self, "hero_is_hurt", [], CONNECT_ONESHOT)

func hero_is_hurt():
	hero_plan_b.collapse()
	hero_plan_b.animator.connect("finished", self, "duke_wake_up", [], CONNECT_ONESHOT)

func duke_wake_up():
	Player.character.stand_up()
	Player.character.animator.connect("finished", Player.character, "look_at", ["left"], CONNECT_ONESHOT)
	var t = get_timer(0.6)
	t.connect("timeout", self, "start_hero_dialog")
	t.start()

func start_hero_dialog():
	hero_plan_b.start_dialog()

########## GUESTS ################

func guests_leave():
# triggered by guest 1
	for i in range(5):
		get_node(str("Guest", i+1)).out()

######### END ############

func the_end():
	get_node("ColorFrame/AnimationPlayer").play("end")
	get_node("ColorFrame/AnimationPlayer").connect("finished", get_tree(), "change_scene", ["res://Credits/Credits.tscn"], CONNECT_ONESHOT)

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