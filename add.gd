extends Button

@onready var user_input: Window = $UserInput

func _ready():
	user_input.hide()
	self.text = "+"
	self.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	print("Button pressed!")
	user_input.show()
