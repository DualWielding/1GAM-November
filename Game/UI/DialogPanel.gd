extends Panel

onready var vscroll = get_node("ScrollContainer")
onready var scroll_container = get_node("ScrollContainer")
onready var script_container = get_node("ScrollContainer/ScriptContainer")
onready var answers_container = get_node("AnswersContainer")
onready var slide_button = get_node("SlideButton")
onready var ap = get_node("AnimationPlayer")

var _hidden_panel = true
var current_length = 0
var _line_length = 35 setget get_line_length

var current_speaker
var current_options

var rich_text_writer_class = preload("res://UI/RichTextWriter.tscn")
var clickable_label_class = preload("res://UI/ClickableText.tscn")
var input_box_class = preload("res://UI/InputBox.tscn")

func set_dialog(body, unformatted_text, options):
	# Add body and options as instance var, in order to connect them
	# To the text
	current_speaker = body
	current_options = options
	
	if _hidden_panel:
		show_panel()
		ap.connect("finished", script_container, "set_dialog", [body, unformatted_text, options], CONNECT_ONESHOT)
	else:
		script_container.set_dialog(body, unformatted_text, options)

func add_text(unformatted_text, method="fade", show_now=false):
	script_container.add_text_to_buffer(unformatted_text, method, show_now)
	script_container.display_texts()

func add_answers():
	if answers_container.get_child_count() > 0:
		return
	
	if current_options.size() == 0:
		return
	
	if current_options.size() == 1 and current_options[0].text == "$i":
		var container = input_box_class.instance()
		answers_container.add_child(container)
		container.set_name(tr("INPUT TAB NAME"))
		container.text_edit.set_placeholder(tr("INPUT PLACEHOLDER"))
		var bu = container.button
		bu.set_h_size_flags(0)
		bu.set_text(str("  ", tr("SUBMIT BUTTON"), "  "))
		bu.connect("pressed", self, "set_player_name", [container])
	else:
		# Add new answers
		for option in current_options:
			var cl = clickable_label_class.instance()
			cl.add_to_group("dialog option")
			answers_container.add_child(cl)
			cl.set_speaker(current_speaker)
			cl.set_option(option)
	
	adjust_answers()

func set_player_name(container):
	var text_edit_node = container.text_edit
	var name = text_edit_node.get_text()
	
	if name.length() < 3:
		text_edit_node.set_text("")
		text_edit_node.set_placeholder(tr("INVALID NAME PLACEHOLDER"))
		return
	
	Player.set_name(name)
	container.queue_free()
	
	# To add the answer to the dialog richText
	script_container.set_dialog(Player.character, str("...", Player.get_name(), ", mon nom est ", Player.get_name(), "."), [], true)
	
	current_speaker.follow_up_dialog(current_options[0])
	clear_answers()

func clear_answers():
	for answer in get_tree().get_nodes_in_group("dialog option"):
		answers_container.remove_child(answer)
#		answer.queue_free()

###### APPARENCE #######

func adjust_answers():
	answers_container.set_size(Vector2(answers_container.get_size().x, (answers_container.get_children()[0].get_size().y) * answers_container.get_child_count()))

func enable_toggling():
	slide_button.get_node("AnimationPlayer").play("slide_right")
	slide_button.set_disabled(false)

func disable_toggling():
	slide_button.get_node("AnimationPlayer").play_backwards("slide_right")
	slide_button.set_disabled(true)

func hide_panel():
	if not _hidden_panel:
		_hidden_panel = true
		ap.play("Slide_left")

func show_panel():
	if _hidden_panel:
		_hidden_panel = false
		ap.play_backwards("Slide_left")

func _on_SlideButton_pressed():
	if not _hidden_panel:
		hide_panel()
	else:
		show_panel()

###### SETGET #####

func get_line_length():
	return _line_length