extends Node3D
var tile_cache = {}
@onready var tile_bucket = $MapTiles
var map_tile = load("res://Map/map_tile.tscn") as PackedScene
const tile_group = "map_tiles"
const speed = 1

@export var android_plugin: AndroidGeolocationPlugin 
@export var log_label: Label

@export_group("Starting Location")
@export_range(-90, 90, 0.000001) var latitude: float = 32.28068820194338
@export_range(-180, 180, 0.000001) var longitude: float = -106.75167801136813

@export_group("Map Config")
# Zoom level from 0-19: 0 is the entire earth in 1 tiles and 19 fully zoomed in
@export_range(0,19) var zoom: int = 19
@export var grid_width = 15
@export var grid_height = 10
@export var tile_scale = 1.0

var new_latitude: float = 0.0
var new_longitude: float = 0.0

var target = Vector3.ZERO
var initialized = false

func _ready():
	var coords = _mercator_projection(latitude, longitude, zoom)
	#var dest = _mercator_projection(new_lat, new_lon, zoom)
	#print("origin: ", coords)
	#print("Target: ", dest)
	generate_grid(coords.x, coords.y, Vector3(0, 0, 0))
	new_latitude = latitude
	new_longitude = longitude
	android_plugin.android_location_updated.connect(self._on_location_update)
	#place_pin_on_tile(32.290052,-106.753893)
	
	
	#log_label.text = str('Location Update: Latitude[',latitude, '], Longitude[', longitude, ']')
	#android_plugin.android_location_permission_updated.connect(self._on_location_permission)
	
#Handles GPS Updates
func _on_location_update(location_dictionary: Dictionary) -> void:
	#log_label = $"../Control/Label"
	new_latitude = location_dictionary["latitude"]
	new_longitude = location_dictionary["longitude"]
	log_label.text = str('Location Update: Latitude[', new_latitude, '], Longitude[', new_longitude, ']')
	
	
func generate_grid(start_x, start_y, origin_positon):
	var x_offset = grid_width / 2 
	var y_offset = grid_height / 2
	var load_count = 0
	for y in grid_height:
		for x in grid_width:
			var x_cord = start_x + x - x_offset
			var y_cord = start_y + y - y_offset
			if !tile_cache.has([x_cord, y_cord]):
				load_count+=1
				var tile = create_tile(x_cord, y_cord)
				tile.position = tile.position + origin_positon + Vector3(x - x_offset, 0, y - y_offset)
	print('Loaded %s new tiles' % load_count)

func create_tile(x: int, y: int) -> Node3D:
	var tile = map_tile.instantiate()
	tile.init(x, y, zoom)
	tile.add_to_group(tile_group)	
	tile_bucket.add_child(tile)
	tile_cache[[x, y]] = tile
	return tile

## move the world under the player
#func _physics_process(delta):
	#target = calculate_movement(new_latitude, new_longitude, latitude, longitude)
	#log_label.text = str('Target: ', target)
	#var moving: bool = true
	#if moving:
		## Move towards the target point at a fixed speed
		#global_transform.origin = global_transform.origin.move_toward(target, speed * delta)
		#
		## Stop moving when close enough to the target
		#if global_transform.origin.distance_to(target) < 0.1:
			#moving = false  # Stop movement when target is reached
			##print("Reached point B")
	
signal movement_state_changed(is_moving: bool)

var was_moving = false  # if it was moving

func _physics_process(delta):
	target = calculate_movement(new_latitude, new_longitude, latitude, longitude)
	log_label.text = str('Target: ', target)

	# if its still moving
	var is_now_moving = global_transform.origin.distance_to(target) >= 0.5

	# if moving status changed
	if is_now_moving != was_moving:
		emit_signal("movement_state_changed", is_now_moving)
		was_moving = is_now_moving

	# map moving logic
	if is_now_moving:
		global_transform.origin = global_transform.origin.move_toward(target, speed * delta)


func _mercator_projection(lat: float, lon: float, zoom: int) -> Vector2:
	var n = 2.0 ** zoom
	var x_tile = floor((lon + 180.0) / 360.0 * n)
	var lat_rad = deg_to_rad(lat)
	var y_tile = floor((1.0 - log(tan(lat_rad) + (1 / cos(lat_rad))) / PI) / 2.0 * n)
	return Vector2(x_tile, y_tile)
	#return {"x": x_tile, "y": y_tile}
	
func calculate_movement(dest_lat: float, dest_lon: float, origin_lat: float, origin_lon: float) -> Vector3:
	var dest = _mercator_projection(dest_lat, dest_lon, zoom)
	var origin = _mercator_projection(origin_lat, origin_lon, zoom)
	var movement = dest - origin
	return Vector3(movement.x, 0 , movement.y) * -1.0

# emitted from player when they move over a new tile
func _on_player_player_entered_world_tile(x, y, tile_position):
	generate_grid(x, y, tile_position)

func _on_tile_purge_timer_timeout():
	for tile in tile_cache.values():
		if tile.global_position.distance_to(Vector3.ZERO) > max(grid_height, grid_width)*2:
			tile_cache.erase([tile.tile_x, tile.tile_y])
			tile.queue_free()

#for show animal hidden spot(not fully working yet)
var marker_scene := preload("res://UI/target_marker.tscn")
var current_marker: Node3D = null

func mark_target_location(lat: float, lon: float):
	var coords = _mercator_projection(lat, lon, zoom)

# Convert tile coordinates to world coordinates on the map
	var x_offset = grid_width / 2
	var y_offset = grid_height / 2
	var world_pos = Vector3(coords.x - x_offset, 0, coords.y - y_offset)

	# clear old marker
	if current_marker:
		current_marker.queue_free()

	current_marker = marker_scene.instantiate()
	current_marker.position = world_pos
	add_child(current_marker)

	print("Marker placed at world position:", world_pos)
