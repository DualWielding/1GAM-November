extends TabContainer

var clickable_label_class = preload("res://ClickableText.tscn")
var answer_tabs = []
onready var main_tab = get_node("MainTab")

var current_speaker
var current_options

func _ready():
	main_tab.set_name(tr("DIALOG PANEL MAIN"))
	main_tab.connect("finished", self, "add_answers")
	
	# Init tabs
	var count = 1
	for option in range(6):
		var cl = clickable_label_class.instance()
		cl.set_name(str(tr("DIALOG PANEL ANSWER"), " ", count))
		cl.add_to_group("dialog option")
		answer_tabs.append(cl)
		count += 1

func set_dialog(body, unformatted_text, options):
	# Add body and options as instance var, in order to connect them
	# To the text
	current_speaker = body
	current_options = options
	
	# Remplace every %n in dialogs with the player name
	var text = unformatted_text
	if Player.get_name():
		text = unformatted_text.replace("%n", Player.get_name())
	
	# Set the new speaker's text
	main_tab.write_text(text)

func add_answers():
	if current_options.size() == 1 and current_options[0].text == "$i":
		var container = VBoxContainer.new()
		container.set_name(tr("INPUT TAB NAME"))
		var te = LineEdit.new()
		te.set_name("NameInput")
		te.set_placeholder(tr("INPUT PLACEHOLDER"))
		var bu = Button.new()
		bu.set_h_size_flags(0)
		bu.set_text(tr("SUBMIT BUTTON"))
		bu.connect("pressed", self, "set_player_name", [container])
		add_child(container)
		container.add_child(te)
		container.add_child(bu)
	else:
		# Add new answers
		var count = 0
		for option in current_options:
			var cl = answer_tabs[count]
			cl.set_speaker(current_speaker)
			cl.set_option(option)
			add_child(cl)
			count += 1
	
	set_current_tab(0)

func set_player_name(container):
	var text_edit_node = container.get_node("NameInput")
	var name = text_edit_node.get_text()
	Player.set_name(name)
	remove_child(container)
	container.queue_free()
	current_speaker.follow_up_dialog(current_options[0])
	clear_answers()

func clear_answers():
	main_tab.clear()
	for answer in get_tree().get_nodes_in_group("dialog option"):
		remove_child(answer)