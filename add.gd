extends Node  
@onready var user_input: Window = $UserInput

@onready var control: Button = $"."

func _ready():
	user_input.hide()
	control.text = "+"
	var confirm_button = user_input.get_node("MarginContainer/QueryContainer/Button")

	control.pressed.connect(self._on_button_pressed)
	
	#var confirm_button = user_input.get_node("MarginContainer/QueryContainer/Button")
	confirm_button.pressed.connect(_on_confirm_pressed)

func _on_button_pressed():
	user_input.show()

func _on_confirm_pressed():
	user_input.hide()
