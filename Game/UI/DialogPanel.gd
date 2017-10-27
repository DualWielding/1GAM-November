extends Panel

var clickable_label_class = preload("res://UI/ClickableText.tscn")
onready var speaker_text = get_node("SpeakerText")
onready var answers_container = get_node("AnswersContainer")
onready var slide_button = get_node("SlideButton")

var _hidden_panel = true

var current_speaker
var current_options

func _ready():
#	Player.character.connect("disabled", slide_button, "hide")
#	Player.character.connect("disabled", self, "show_panel")
#	Player.character.connect("enabled", slide_button, "show")
#	Player.character.connect("enabled", selide_button, "hide_panel")
	
#	hide_panel()
	speaker_text.connect("finished", self, "add_answers")

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
	speaker_text.append_bbcode(str("[i]", body.get_name(), "[/i]\n\n"))
	speaker_text.write_text(text) # Should fill the thing...

func add_answers():
	if answers_container.get_child_count() > 0:
		return
	
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
		answers_container.add_child(container)
		container.add_child(te)
		container.add_child(bu)
	else:
		# Add new answers
		var count = 0
		for option in current_options:
			var cl = clickable_label_class.instance()
			cl.add_to_group("dialog option")
			answers_container.add_child(cl)
			cl.set_speaker(current_speaker)
			cl.set_option(option)
			count += 1
	
	adjust_answers()

func set_player_name(container):
	var text_edit_node = container.get_node("NameInput")
	var name = text_edit_node.get_text()
	Player.set_name(name)
	remove_child(container)
	container.queue_free()
	
	#TODO better than this !
	# To add the answer to the dialog richText
	speaker_text.append_bbcode(str("[i]", Player.get_name(), "[/i]\n\n"))
	speaker_text.append_bbcode(str(". . . ", Player.get_name(), ", mon nom est ", Player.get_name(), ".", "\n\n"))
	
	current_speaker.follow_up_dialog(current_options[0])
	clear_answers()

func clear_answers():
	for answer in get_tree().get_nodes_in_group("dialog option"):
		answers_container.remove_child(answer)
		answer.queue_free()

###### APPARENCE #######

func adjust_answers():
	answers_container.set_size(Vector2(answers_container.get_size().x, (answers_container.get_children()[0].get_size().y) * answers_container.get_child_count()))

func enable_toggling():
	slide_button.set_disabled(false)

func disable_toggling():
	slide_button.set_disabled(true)

func hide_panel():
	if not _hidden_panel:
		_hidden_panel = true
		get_node("AnimationPlayer").play("Slide_left")
		slide_button.set_text(">")

func show_panel():
	if _hidden_panel:
		_hidden_panel = false
		get_node("AnimationPlayer").play_backwards("Slide_left")
		slide_button.set_text("<")

func _on_SlideButton_pressed():
	if not _hidden_panel:
		hide_panel()
	else:
		show_panel()
