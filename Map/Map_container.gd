extends Node3D

var tile_cache = {}
@onready var tile_bucket = $MapTiles
var map_tile = load("res://Map/map_tile.tscn") as PackedScene
const tile_group = "map_tiles"
const speed = 1
var target: Vector3 = Vector3.ZERO

@export var android_plugin: AndroidGeolocationPlugin 
@export var log_label: Label

@export_group("Starting Location")
@export_range(-90, 90, 0.000001) var latitude: float = 32.28068820194338
@export_range(-180, 180, 0.000001) var longitude: float = -106.75167801136813

@export_group("Map Config")
@export_range(0,19) var zoom: int = 19
@export var grid_width = 15
@export var grid_height = 10
@export var tile_scale = 1.0

var new_latitude: float = 0.0
var new_longitude: float = 0.0

signal movement_state_changed(is_moving: bool)
var was_moving = false

var center_coord : Vector2
@onready var marker_scene := preload("res://UI/target_marker.tscn") as PackedScene
var current_marker : Node3D  = null

var missions = [
	{
		"name":"Home-HY-Home Road",
		"tests":[
			{"name":"Test A", "lat":32.3734502, "lon":-106.7518931, "radius":50.0, "state":0, "marker":null},
			{"name":"Test B", "lat":32.350031, "lon":-106.751079, "radius":50.0, "state":0, "marker":null},
		],
		"final":{"name":"Final", "lat":32.3734502, "lon":-106.7518931, "radius":50.0, "state":-1, "marker":null},
		"directions": [
			{ "lat":32.3734502, "lon":-106.7518931},
			{ "lat":32.3731260, "lon":-106.7519242},
			{ "lat":32.3728057, "lon":-106.7519324},
			{ "lat":32.3718206, "lon":-106.7529642},
			{ "lat":32.3707164, "lon":-106.7535740},
			{ "lat":32.3701065, "lon":-106.7540504},
			{ "lat":32.3692474, "lon":-106.7532325},
			{ "lat":32.3644012, "lon":-106.7500134},
			{ "lat":32.3583451, "lon":-106.7577541},
			{ "lat":32.3502826, "lon":-106.7499550},
		  	{ "lat":32.3504133, "lon":-106.7495005},
			{ "lat":32.3734502, "lon":-106.7518931},

		]
	},
	{
		"name":"Science hall 2",
		"tests":[
			{"name":"Test A", "lat":32.2804731, "lon":-106.7527608, "radius":2, "state":0, "marker":null},
			{"name":"Test B", "lat":32.2804615, "lon":-106.7524413, "radius":2, "state":0, "marker":null},
		],
		"final":{"name":"Final", "lat":32.2807701, "lon":-106.7520105, "radius":2, "state":-1, "marker":null},
		"directions": [
		  { "lat":32.2804731, "lon":-106.7527608},
		  { "lat":32.2804099, "lon":-106.7527416},
		  { "lat":32.2804615, "lon":-106.7524413},
		  { "lat":32.2806506, "lon":-106.7524971},
		  { "lat":32.2807701, "lon":-106.7520105},

		]
	},
		{
		"name":"Science hall 5",
		"tests":[
			{"name":"Test A", "lat":32.2804731, "lon":-106.7527608, "radius":5, "state":0, "marker":null},
			{"name":"Test B", "lat":32.2804615, "lon":-106.7524413, "radius":5, "state":0, "marker":null},
		],
		"final":{"name":"Final", "lat":32.2807701, "lon":-106.7520105, "radius":5, "state":-1, "marker":null},
		"directions": [
		  { "lat":32.2804731, "lon":-106.7527608},
		  { "lat":32.2804099, "lon":-106.7527416},
		  { "lat":32.2804615, "lon":-106.7524413},
		  { "lat":32.2806506, "lon":-106.7524971},
		  { "lat":32.2807701, "lon":-106.7520105},

		]
	},
	{
		"name":"Dripping Spring",
		"tests":[
			{"name":"Test A", "lat":32.3053962, "lon":-106.5917835, "radius":2, "state":0, "marker":null},
			{"name":"Test B", "lat":32.3053649, "lon":-106.5896424, "radius":2, "state":0, "marker":null},
		],
		"final":{"name":"Final", "lat":32.3047000, "lon":-106.5880100, "radius":2, "state":-1, "marker":null},
		"directions": [
		  { "lat":32.3046056, "lon":-106.5935526},
		  { "lat":32.3053962, "lon":-106.5917835},
		  { "lat":32.3056408, "lon":-106.5911296},
		  { "lat":32.3058421, "lon":-106.5905645},
		  { "lat":32.3053649, "lon":-106.5896424},
		  { "lat":32.3047000, "lon":-106.5880100},

		]
	},
]
var current_mission = null

@onready var quiz_popup: AcceptDialog = $"../CanvasLayer/AnimalQuiz"
@onready var find_btn : Button = $"../CanvasLayer/RouteSelector"
@onready var selector: AcceptDialog  = $"../CanvasLayer/RouteSelector/RouteSelector"

@onready var route_path: Path3D = $Path3D
var route_mesh: MeshInstance3D = null

func _ready():
	center_coord = _mercator_projection(latitude, longitude, zoom)
	var origin_tile = Vector2(floor(center_coord.x), floor(center_coord.y))
	generate_grid(origin_tile.x, origin_tile.y, Vector3.ZERO)

	new_latitude = latitude
	new_longitude = longitude
	android_plugin.android_location_updated.connect(_on_location_update)
	find_btn.pressed.connect(Callable(self, "_on_find_routes_pressed"))
	selector.connect("route_chosen", Callable(self, "_on_route_selected"))
	selector.hide()

	quiz_popup.hide()
	#await get_tree().process_frame
	#quiz_popup.show_quiz()
	#showMission(missions[0])
	
func _on_location_update(loc : Dictionary) -> void:
	new_latitude  = loc["latitude"]
	new_longitude = loc["longitude"]
	log_label.text = "Lat: %f  Lon: %f" % [new_latitude, new_longitude]

	if current_mission == null:
		print("null")
		return
		
	for t in current_mission.tests:
		print("IN MISSON")
		if t.state == 0:
			var d = _haversine(new_latitude, new_longitude, t.lat, t.lon)
			print("🔍 Checking test point:", t.name,
				  " distance=", d, " radius=", t.radius)
			if d <= t.radius:
				t.state = 1
				print("enter quiz point：", t.name, "（distance", d, "meter）")

				print(t.name, " state turns to 1")
				t.marker.modulate = Color(0.5, 0.5, 0.5)
				print("ready to pop quiz：", t.name)				
				quiz_popup.show_quiz()

	if current_mission.tests.all(func(x): return x.state == 1) and current_mission.final.state < 0:
		current_mission.final.state = 0
		_place_marker(current_mission.final, Color(1, 0, 0))

func showMission(mission : Dictionary) -> void:
	current_mission = mission
	for child in tile_bucket.get_children():
		if child.name.begins_with("Marker_"):
			child.queue_free()
	for t in mission.tests:
		t.state = 0
		_place_marker(t, Color(1,1,0))
	mission.final.state = -1
	center_coord = _mercator_coord(latitude, longitude, zoom)

#func _place_marker(p : Dictionary, col : Color) -> void:
	#var coord = _mercator_coord(p.lat, p.lon, zoom)
	#var delta = coord - center_coord
	#var m = marker_scene.instantiate() as Node3D
	#tile_bucket.add_child(m)
	#m.position = Vector3(delta.x * tile_scale, 0, delta.y * tile_scale)
	#m.modulate = col
	#m.name = "Marker_%s" % p.name
	#p.marker = m
func _place_marker(p: Dictionary, col: Color) -> void:
	# calculate the tile coord
	var coord = _mercator_coord(p.lat, p.lon, zoom)
	var delta = coord - center_coord

	# instantiate and add to tile_bucket
	var m = marker_scene.instantiate() as Node3D
	tile_bucket.add_child(m)

	# place it at the right spot
	m.position = Vector3(delta.x * tile_scale, 0, delta.y * tile_scale)

	# check in journal
	print("Placed marker for '%s' at global %s" % [p.name, m.global_transform.origin])
	print("children of marker:", m.get_child_count(), "  node itself:", m)

	# update color according to status
	if m.has_node("PinIcon"):
		var sprite = m.get_node("PinIcon") as Sprite3D
		sprite.modulate = col
	else:
		(m as Sprite3D).modulate = col

	m.name = "Marker_%s" % p.name
	p.marker = m

func generate_grid(start_x: int, start_y: int, origin: Vector3) -> void:
	var x_off = grid_width / 2
	var y_off = grid_height / 2
	var load_count = 0
	for y in grid_height:
		for x in grid_width:
			var xi = start_x + x - x_off
			var yi = start_y + y - y_off
			if not tile_cache.has([xi, yi]):
				load_count += 1
				var tile = create_tile(xi, yi)
				tile.position = origin + Vector3(x - x_off, 0, y - y_off)
	print("generate_grid() loaded:", load_count)

func create_tile(x: int, y: int) -> Node3D:
	var tile = map_tile.instantiate()
	tile.init(x, y, zoom)
	tile.add_to_group(tile_group)
	tile_bucket.add_child(tile)
	tile_cache[[x, y]] = tile
	return tile

func _physics_process(delta):
	target = calculate_movement(new_latitude, new_longitude, latitude, longitude)
	var is_moving = global_transform.origin.distance_to(target) >= 0.5
	if is_moving != was_moving:
		emit_signal("movement_state_changed", is_moving)
		was_moving = is_moving
	if is_moving:
		global_transform.origin = global_transform.origin.move_toward(target, speed * delta)

func _on_player_player_entered_world_tile(x, y, tile_position):
	generate_grid(x, y, tile_position)

func _haversine(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
	var R = 6371000.0
	var φ1 = deg_to_rad(lat1)
	var φ2 = deg_to_rad(lat2)
	var dφ = deg_to_rad(lat2 - lat1)
	var dλ = deg_to_rad(lon2 - lon1)
	var a = sin(dφ/2) * sin(dφ/2) + cos(φ1) * cos(φ2) * sin(dλ/2) * sin(dλ/2)
	var c = 2 * atan2(sqrt(a), sqrt(1 - a))
	return R * c

func _mercator_projection(lat: float, lon: float, zoom: int) -> Vector2:
	var n = 2.0 ** zoom
	var x_tile = floor((lon + 180.0) / 360.0 * n)
	var lat_rad = deg_to_rad(lat)
	var y_tile = floor((1.0 - log(tan(lat_rad) + (1 / cos(lat_rad))) / PI) / 2.0 * n)
	return Vector2(x_tile, y_tile)

func _mercator_coord(lat: float, lon: float, zoom: int) -> Vector2:
	var n = 2.0 ** zoom
	var x = (lon + 180.0) / 360.0 * n
	var lat_r = deg_to_rad(lat)
	var y = (1.0 - log(tan(lat_r) + 1.0/cos(lat_r)) / PI) / 2.0 * n
	return Vector2(x, y)

func calculate_movement(dest_lat: float, dest_lon: float, origin_lat: float, origin_lon: float) -> Vector3:
	var dest = _mercator_projection(dest_lat, dest_lon, zoom)
	var origin = _mercator_projection(origin_lat, origin_lon, zoom)
	var movement = dest - origin
	return Vector3(movement.x, 0 , movement.y) * -1.0

func get_nearby_routes(max_dist_meters: float) -> Array:
	var nearby = []
	for route in missions:
		# combine all the quiz points anf final point
		var all_points = route.tests + [ route.final ]
		var best = INF
		for p in all_points:
			var d = _haversine(new_latitude, new_longitude, p.lat, p.lon)
			best = min(best, d)
		if best <= max_dist_meters:
			nearby.append({ "route": route, "dist": best })
	nearby.sort_custom( Callable(self, "_sort_by_dist") )
	return nearby

func _sort_by_dist(a, b):
	return int(a.dist - b.dist)

func _on_find_routes_pressed() -> void:
	var names = []
	for route in missions:
		var dist_m = 0.0
		var pts = route.directions
		for i in range(pts.size() - 1):
			dist_m += _haversine(pts[i].lat, pts[i].lon, pts[i+1].lat, pts[i+1].lon)
		var dist_mi = dist_m / 1609.34
		var display_name = "%s – %.2f miles" % [route.name, dist_mi]
		names.append(display_name)
	print(names)
	selector.set_routes(names)
	selector.popup_centered()


func _on_route_selected(idx: int) -> void:
	var chosen = missions[idx]
	_draw_route_immediate(chosen)
	showMission(chosen)

func _draw_route_immediate(route: Dictionary) -> void:
	# remove old route
	var old_mesh = tile_bucket.get_node_or_null("RouteMesh")
	if old_mesh:
		old_mesh.queue_free()

	# make new ImmediateMesh，and set it to PRIMITIVE_LINES
	var im = ImmediateMesh.new()
	im.surface_begin(Mesh.PRIMITIVE_LINES)

	# set all the points
	var pts = route.directions
	# draw with order
	for i in range(pts.size() - 1):
		var p1 = pts[i]
		var p2 = pts[i + 1]
		# Mercator convert to tile coord
		var c1 = _mercator_coord(p1.lat, p1.lon, zoom)
		var c2 = _mercator_coord(p2.lat, p2.lon, zoom)
		# use center_coord to convert to world coord
		var w1 = Vector3((c1.x - center_coord.x) * tile_scale, 0, (c1.y - center_coord.y) * tile_scale)
		var w2 = Vector3((c2.x - center_coord.x) * tile_scale, 0, (c2.y - center_coord.y) * tile_scale)

		im.surface_add_vertex(w1)
		im.surface_add_vertex(w2)
	im.surface_end()
	
	# addin to scene
	var mi = MeshInstance3D.new()
	mi.name = "RouteMesh"
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = Color(1, 0.8, 0)  # yellow
	mi.mesh = im
	mi.material_override = mat
	tile_bucket.add_child(mi)
