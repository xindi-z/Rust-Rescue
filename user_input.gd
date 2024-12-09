#extends Window
#
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


extends Window
@onready var latitude_input: LineEdit = $MarginContainer/QueryContainer/LatContainer/LineEdit
@onready var longitude_input: LineEdit = $MarginContainer/QueryContainer/LonContainer/LineEdit

@onready var confirm_button: Button = $MarginContainer/QueryContainer/Button

func _ready():
	print("ready")
