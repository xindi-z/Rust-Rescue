extends Node3D

signal player_entered_world_tile(x, y, tile_position)

var current_tile

@export var ray_cast_per_second: float = 4 
var time_since_last_cast: float = 0.0

func _ready():
	var anim_player = $michelle/AnimationPlayer
	if anim_player == null:
		push_error("AnimationPlayer not found at path: $michelle/AnimationPlayer")
	else:
		print("AnimationPlayer found.")
#	connect signal to function _on_movement_state_changed
	$"../Map_container".movement_state_changed.connect(_on_movement_state_changed)

#controlling character animations according to map
func _on_movement_state_changed(is_moving):
	var anim_player = $michelle/AnimationPlayer
	var anim = "Walking0" if is_moving else "Ideal"

	if not anim_player.has_animation(anim):
		push_error("Animation not found: " + anim)
		return
		
	if anim_player.current_animation != anim:
		anim_player.play(anim)
		print("Now playing animation: ", anim)
	
	# controlling the character direction
	if is_moving:
		var map = $"../Map_container"
		var dir = map.target - map.global_transform.origin
		if dir.length() > 0.01:
			var forward = dir.normalized()
			look_at(global_transform.origin + forward, Vector3.UP)
		print("Forward vector:", dir)  
		print("Player global Z basis:", global_transform.basis.z)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# reduce unnessesary ray casting
	if time_since_last_cast < 1.0/ray_cast_per_second:
		time_since_last_cast += delta
	else:
		time_since_last_cast = 0.0
		var tile = cast_ray_down()
		if tile and (!current_tile or (current_tile.tile_x != tile.tile_x or current_tile.tile_y != tile.tile_y)) :
			current_tile = tile
			# connects to the map_container to load new tiles if necesary as the player moves
			emit_signal("player_entered_world_tile", tile.tile_x, tile.tile_y, tile.position)

# find the tile the player is above, so we know when to expand the map
func cast_ray_down() -> Object:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(position, position + Vector3(0, -10, 0))
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	# Check if there was a collision
	if result and !result.is_empty():
		return result.collider
	else:
		# we're lost/off the map 
		return null
