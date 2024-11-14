extends Node3D
var tile_cache = {}
@onready var tile_bucket = $MapTiles
var map_tile = load("res://Map/map_tile.tscn") as PackedScene
const tile_group = "map_tiles"
const speed = 1

@export_group("Starting Location")
@export_range(-90, 90, 0.000001) var latitude: float = 32.28068820194338
@export_range(-180, 180, 0.000001) var longitude: float = -106.75167801136813

@export_group("Map Config")
# Zoom level from 0-19: 0 is the entire earth in 1 tiles and 19 fully zoomed in
@export_range(0,19) var zoom: int = 19
@export var grid_width = 15
@export var grid_height = 10

func _ready():
	var coords = _mercator_projection(latitude, longitude, zoom)
	generate_grid(coords["x"], coords["y"], Vector3(0, 0, 0))

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
	#print('Loaded %s new tiles' % load_count)

func create_tile(x: int, y: int) -> Node3D:
	var tile = map_tile.instantiate()
	tile.init(x, y, zoom)
	tile.add_to_group(tile_group)	
	tile_bucket.add_child(tile)
	tile_cache[[x, y]] = tile
	return tile

# move the world under the player
func _physics_process(delta):
	var direction = Vector3.ZERO    
	if Input.is_action_pressed("up"):
		direction.z += 1
	if Input.is_action_pressed("down"):
		direction.z -= 1
	if Input.is_action_pressed("left"):
		direction.x += 1
	if Input.is_action_pressed("right"):
		direction.x -= 1
	
	var movement = direction * speed * delta
	for tile in tile_bucket.get_children():
		tile.position = tile.position + movement

# converts latitude and longitude into grid coordinates, correcting for the
# distortion that happens when you represent the globe on a 2D map
func _mercator_projection(lat: float, lon: float, zoom: int ) -> Dictionary: 
	var n = 2.0 ** zoom
	var x_tile = floor((lon + 180.0) / 360.0 * n)
	var lat_rad = deg_to_rad(lat)
	var y_tile = floor((1.0 - log(tan(lat_rad) + (1 / cos(lat_rad))) / PI) / 2.0 * n)
	return {"x": x_tile, "y": y_tile}

# emitted from player when they move over a new tile
func _on_player_player_entered_world_tile(x, y, tile_position):
	generate_grid(x, y, tile_position)

func _on_tile_purge_timer_timeout():
	for tile in tile_cache.values():
		if tile.global_position.distance_to(Vector3.ZERO) > max(grid_height, grid_width)*2:
			tile_cache.erase([tile.tile_x, tile.tile_y])
			tile.queue_free()
