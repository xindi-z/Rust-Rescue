extends Node2D


@onready var game_map: Control = $GameMap
@onready var player: Area2D = $player
@export var speed = 400

func _ready() -> void:
	player.position_updated.connect(Callable(self, "update_map"))

func update_map(latitude, longitude) -> void:
	print(latitude, longitude)
	
func _process(delta):
	var velocity = Vector2.ZERO  # 移动向量

	# 获取玩家输入 (上下左右)
	if Input.is_action_pressed("move_east"):
		velocity.x += 1
	if Input.is_action_pressed("move_west"):
		velocity.x -= 1
	if Input.is_action_pressed("move_south"):
		velocity.y += 1
	if Input.is_action_pressed("move_north"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed * delta  # 计算移动方向和速度

		# 不改变玩家位置，而是移动地图位置（向相反方向平移）
		game_map.position -= velocity
