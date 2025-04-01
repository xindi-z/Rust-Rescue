extends Window

signal animal_rescued

@onready var prompt_label = $VBoxContainer/Label
@onready var close_button = $VBoxContainer/Button

func _ready():
	close_button.pressed.connect(_on_close_button_pressed)
	hide()

#when prompt closed, send signal to call the dialog and inventory
func _on_close_button_pressed():
	hide()
	emit_signal("animal_rescued")
	await get_tree().create_timer(1.0).timeout
	print("Waited 1 second after rescue")

#show prompt
func show_prompt():
	show()
