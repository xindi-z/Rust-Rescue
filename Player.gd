extends Node2D

@export var speed: float = 200.0  # Movement speed

func _process(delta: float):
	var direction = Vector2.ZERO

	# Check for keyboard input
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1

	# Normalize the direction and move the character
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		position += direction * speed * delta
