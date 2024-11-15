extends Area2D

@export var speed: float = 200

var latitude: float = 32.290052  # 初始纬度，例如旧金山
var longitude: float = -106.753893  # 初始经度



var meters_per_unit: float = 0.0001

signal position_updated(latitude: float, longitude: float)

#func _on_position_updated(latitude: float, longitude: float) -> void:
	#print("新位置：", latitude, longitude)
	#

func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_east"):
		velocity.x += 1
	if Input.is_action_pressed("move_west"):
		velocity.x -= 1
	if Input.is_action_pressed("move_south"):
		velocity.y += 1
	if Input.is_action_pressed("move_north"):
		velocity.y -= 1

	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * speed
		position += velocity * delta

		# 根据位置更新经纬度
		latitude += velocity.y * meters_per_unit * delta
		longitude += velocity.x * meters_per_unit * delta
		#print(latitude)
		#print(longitude)

		# 触发靠近边界的信号，发送当前位置经纬度
		# 发射更新后的经纬度信号

		emit_signal("position_updated", latitude, longitude)
	
#@export var speed = 400 # How fast the player will move (pixels/sec).
#var screen_size # Size of the game window.
#signal position_updated(new_position: Vector2)
#
#@export var speed: float = 200
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	##screen_size = get_viewport_rect().size

	#pass
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#var velocity = Vector2.ZERO # The player's movement vector.
	#if Input.is_action_pressed("move_east"):
		#velocity.x += 1
	#if Input.is_action_pressed("move_west"):
		#velocity.x -= 1
	#if Input.is_action_pressed("move_south"):
		#velocity.y += 1
	#if Input.is_action_pressed("move_north"):
		#velocity.y -= 1
	#if velocity != Vector2.ZERO:
		#velocity = velocity.normalized() * speed
		#position += velocity * delta
		#print(position)
		#emit_signal("position_updated", global_position)  # 发出位置更新信号
	##if velocity.length() > 0:
		##velocity = velocity.normalized() * speed
		##$test.play()
	##else:
		##$test.stop()
	##position += velocity * delta
	###position = position.clamp(Vector2.ZERO, screen_size)
