extends Panel

onready var script_container = get_node("ScrollContainer/ScriptContainer")
onready var answers_container = get_node("AnswersContainer")
onready var slide_button = get_node("SlideButton")

var _hidden_panel = true
var current_length = 0
var _original_x_size = 0

var current_speaker
var current_options

var rich_text_writer_class = preload("res://UI/RichTextWriter.tscn")
var clickable_label_class = preload("res://UI/ClickableText.tscn")

func set_dialog(body, unformatted_text, options):
	# Add body and options as instance var, in order to connect them
	# To the text
	current_speaker = body
	current_options = options
	
	# Fade the name of the speaker in
	add_text(str("[center][i]", body.get_name(), "[/i][/center]"), "fade")
	
	# Write the speaker's dialog
	var rtw = add_text(unformatted_text, "write")
	rtw.connect("finished", self, "add_answers")

func add_text(text, method="fade", is_stage_direction = false, is_name = false):
	script_container.set_size(get_node("ScrollContainer").get_size()) # seems we need that
	var wrapper = Control.new()
	var rtw = rich_text_writer_class.instance()
	rtw.set_text_up(text, method)
#	rtw.set_pos(Vector2(0, current_length))
	
	if _original_x_size == 0:
		_original_x_size = script_container.get_size().x
	
	rtw.set_custom_minimum_size(Vector2(_original_x_size, 20 + (rtw.get_text().length() / 40) * 20))
	wrapper.set_custom_minimum_size(rtw.get_custom_minimum_size())
	wrapper.add_child(rtw)
	script_container.add_child(wrapper)
#	current_length += rtw.get_size().y + 20
	
#	print(script_container.get_size().y)
	return rtw

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
	
	# To add the answer to the dialog richText
	add_text(str("[i]", Player.get_name(), "[/i]"), "fade")
	add_text(str(". . . ", Player.get_name(), ", mon nom est ", Player.get_name(), "."), "fade")
	
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

func _on_ScriptContainer_minimum_size_changed():
	var t = Timer.new()
	t.set_one_shot(true)
	t.set_wait_time(0.1)
	t.connect("timeout", self, "auto_scroll_down")
	add_child(t)
	t.start()

func auto_scroll_down():
	var vscroll = get_node("ScrollContainer")
	vscroll.set_v_scroll(script_container.get_size().y)