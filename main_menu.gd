extends Control

func _ready():
	$VBoxContainer/Button.pressed.connect(_on_start_game_button_pressed)
	$VBoxContainer/Button2.pressed.connect(_on_exit_button_pressed)
	
func _on_start_game_button_pressed():
	print("Starting game...")
	# Replace this with your game scene loading code
	get_tree().change_scene_to_file("res://main.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
