extends Node

var cards = {}

func _ready():
	# Load cards from JSON file
	var path = "res://GeneralData/Cards.json"
	var file = File.new()
	
	if !file.file_exists(path):
		print("Soz, but your GeneralData/Cards.json file does not exist.")
		get_tree().quit()
	
	file.open(path, file.READ)
	var text = file.get_as_text()
	cards.parse_json(text)
	file.close()
	
	for card_name in cards:
		print(card_name)
		cards[card_name].img = load(str("res://Sprites/Cards/", card_name.to_lower(), ".png"))
		cards[card_name].text = load(str("res://Sprites/Cards/", card_name.to_lower()," text.png"))
		print(cards[card_name].text)
		cards[card_name].name = load(str("res://Sprites/Cards/", card_name.to_lower(), " name.png"))
		print("---------------")

func get(card_unique_name):
	if !cards.has(card_unique_name):
		return null
	return cards[card_unique_name]