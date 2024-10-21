# MapTile.gd
extends TextureRect

@export var api_key: String = "AIzaSyCWkRyynUhoA9BGFVcTf_D96QJ7WsQ0Lks"  # Replace with your actual API key
@export var center_latitude: float = 32.27994043230601  # Default to San Francisco
@export var center_longitude: float = -106.75172853695162 
@export var zoom: int = 15  # Zoom level

@export var map_width: int = 1280  # Set the width of the map
@export var map_height: int = 1280  # Set the height of the map


func _ready() -> void:
	download_map_tile()

func download_map_tile() -> void:
	#var url = "https://maps.googleapis.com/maps/api/staticmap?center=%s,%s&zoom=%d&size=640x640&key=%s" % [
		#center_latitude, center_longitude, zoom, api_key
	#]
	#var url = "https://maps.googleapis.com/maps/api/staticmap?center=%s,%s&zoom=%d&size=%dx%d&key=%s" % [
		#center_latitude, center_longitude, zoom, map_width, map_height, api_key
	#]
	
	var url = "https://maps.googleapis.com/maps/api/staticmap?center=%s,%s&zoom=%d&size=640x640&scale=2&key=%s" % [
		center_latitude, center_longitude, zoom, api_key
	]
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	http_request.request(url)

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var image = Image.new()
		image.load_png_from_buffer(body)
		texture = ImageTexture.create_from_image(image)
	else:
		print("Failed to load map: ", response_code)
