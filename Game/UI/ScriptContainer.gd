extends VBoxContainer

var rich_text_writer_class = preload("res://UI/RichTextWriter.tscn")

var buffer = []

var _original_x_size = 0
onready var _line_length = get_parent().get_parent().get_line_length()

signal can_pop_answers

func add_text_to_buffer(unformatted_text, method="fade", show_now=false):
	var text = unformatted_text
	
	set_size(get_parent().get_size()) # seems we need that
	
	var wrapper = Control.new()
	var rtw = rich_text_writer_class.instance()
	
	rtw.set_text_up(text, method)
	
	if _original_x_size == 0:
		_original_x_size = get_size().x
	
	rtw.set_custom_minimum_size(Vector2(_original_x_size, _line_length + 10 + (rtw.get_text().length() / _line_length) * (_line_length/1.5)))
	wrapper.set_custom_minimum_size(rtw.get_custom_minimum_size())
	wrapper.add_child(rtw)
	
	buffer.append(wrapper)
	
	if show_now:
		_show_first_text()

func display_texts():
	var count = 0
	while count < buffer.size() - 1:
		buffer[count].get_children()[0].connect("finished", self, "_show_first_text", [], CONNECT_ONESHOT)
		count += 1
	_show_first_text()

func _show_first_text():
	if buffer.size() == 0 or (get_child_count() > 0 and !get_children()[get_child_count() - 1].get_children()[0].is_finished()):
		return
	
	var rtw = buffer[0]
	add_child(buffer[0])
	buffer.pop_front()
	
	get_parent().start_scrolling()

func _parse_text(unformatted_text):
	var text_parts = []
	var current_part = 0
	var current_char = 0
	
	while current_char < unformatted_text.length():
		
		# If italics is find, it means it's a stage direction
		if unformatted_text[current_char] == "[" and unformatted_text[current_char + 1] == "i":
			text_parts.append({ "text": "", "stage_direction": true })
			
			# For the base case
			if current_char > 0:
				current_part += 1
			
			
			while unformatted_text[current_char] != "/" or unformatted_text[current_char+1] != "i" or unformatted_text[current_char + 2] != "]":
				text_parts[current_part].text = str(text_parts[current_part].text, unformatted_text[current_char])
				current_char += 1
			text_parts[current_part].text = str(text_parts[current_part].text, "/i]")
			current_char += 3
			
			current_part += 1
		else:
			if current_part + 1 > text_parts.size():
				text_parts.append({ "text": "", "stage_direction": false })
			
			text_parts[current_part].text = str(text_parts[current_part].text, unformatted_text[current_char])
			current_char += 1
	
	return text_parts

func set_dialog(body, unformatted_text, options, player_speaking=false):
	var text_parts = _parse_text(unformatted_text)
	var current_part = 0
	# Fade the name of the speaker in
	if text_parts[0].stage_direction:
		add_text_to_buffer(str("[center][i]", body.get_name().to_upper(), ", ", text_parts[0].text.to_lower(), "[/i][/center]"), "fade_fast")
		current_part += 1
	else:
		add_text_to_buffer(str("[center][i]", body.get_name().to_upper(), "[/i][/center]"), "fade_fast")
	
	while current_part < text_parts.size():
		if text_parts[current_part].stage_direction:
			add_text_to_buffer(str("[right]", text_parts[current_part].text, "[right]"), "fade")
		elif player_speaking:
			add_text_to_buffer(text_parts[current_part].text, "fade")
		else:
			add_text_to_buffer(text_parts[current_part].text, "write")
		current_part += 1
	
	if !player_speaking:
		buffer[buffer.size() -1].get_children()[0].connect("finished", Player.ui.dialog_panel, "add_answers")
	
	display_texts()

func show_last():
	if get_child_count() < 1:
		return 
	
	var last_child = get_children()[get_child_count() - 1].get_children()[0] # wrapper
	if !last_child.finished:
		last_child.finish()

func get_last_dialog_section_idx():
	if buffer.size() == 0:
		return -1
	else:
		return buffer[buffer.size() - 1]