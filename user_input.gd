extends AcceptDialog

@onready var latitude_input: LineEdit = $MarginContainer/QueryContainer/LatContainer/LineEdit
@onready var longitude_input: LineEdit = $MarginContainer/QueryContainer/LonContainer/LineEdit
@onready var confirm_button: Button = $MarginContainer/QueryContainer/Button

func _ready():
	print("UserInput window ready")
	self.confirmed.connect(_on_confirm_pressed)

func _on_confirm_pressed():
	var lat = latitude_input.text.to_float()
	var lon = longitude_input.text.to_float()
	print("Input received -> Latitude:", lat, "Longitude:", lon)
	
	var map_container = get_node("/root/Main/Map_container")

	if map_container:
		map_container.mark_target_location(lat, lon)
	self.hide()
