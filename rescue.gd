extends Node

var ble_plugin
@onready var rescued_prompt: Window = $RescuedPrompt
var target_address := ""

func _ready():
#	getting ble plugin instance
	ble_plugin = Engine.get_singleton("BLEPlugin") if Engine.has_singleton("BLEPlugin") else null
	if not ble_plugin:
		push_error("BLE Plugin not found")
		return

	# give a corresponding function for plugin events
	ble_plugin.connect("ble_initialized", Callable(self, "_on_ble_ready"))
	ble_plugin.connect("device_found",        Callable(self, "_on_device_found"))
	ble_plugin.connect("device_connected",    Callable(self, "_on_device_connected"))
	ble_plugin.connect("device_disconnected", Callable(self, "_on_device_disconnected"))
	ble_plugin.connect("service_discovery_success", Callable(self, "_on_service_discovery_success"))
	ble_plugin.connect("characteristic_changed",    Callable(self, "_on_characteristic_changed"))
	ble_plugin.connect("scan_failed",         Callable(self, "_on_scan_failed"))
	
	# call initialize from plugin, get singal ble_initialized when its done
	ble_plugin.initialize()

#scan all the devices around
func _on_ble_ready():
	print("BLE initialized, start scanning")
	ble_plugin.startScan()

#if found ForceSensorESP32, stop scan, and try to connect
func _on_device_found(name, address):
	if name == "ForceSensorESP32":
		ble_plugin.stopScan()
		target_address = address
		_attempt_connect()

#try to connect
func _attempt_connect():
	print("Attempting to connect to", target_address)
	ble_plugin.connectToDeviceByAddress(target_address)

#if disconnected (may use for later)
func _on_device_disconnected(address, name):
		print("discoonected")

#connected
func _on_device_connected(address, name):
	print("Connected to device:", name, "(", address, ")")

#check if all the services worked 
func _on_service_discovery_success(address):
	await get_tree().create_timer(1.0).timeout
	var char_uuid = "beb5483e-36e1-4688-b7f5-ea07361b26a8"
	if ble_plugin.hasCharacteristic(address, char_uuid) and ble_plugin.isNotifiable(address, char_uuid):
		print(">> hasChar?", ble_plugin.hasCharacteristic(address, char_uuid))
		print(">> isNotifiable?", ble_plugin.isNotifiable(address, char_uuid))
		print(">> isIndicatable?", ble_plugin.isIndicatable(address, char_uuid))
		var ok = ble_plugin.setCharacteristicNotifications(address, char_uuid, true)
		print(">> setCharacteristicNotifications returned:", ok)
	else:
		push_warning("Cannot subscribe to pressure characteristic")

#when revices pressure sensor signal, trigger fucntion show_prompt
func _on_characteristic_changed(address, uuid, value):
	print("Characteristic changed from", address, "UUID:", uuid, "Value:", value)
	var str_value = value.get_string_from_utf8()
	if str_value == "a":
		print("Received sensor signal `a`")
		rescued_prompt.show_prompt()	
		
func _on_scan_failed(error):
	print("Scan failed: ", error)

func _on_characteristic_read(address, uuid, value):
	print("Characteristic read from ", address, ", UUID: ", uuid, ", Value: ", value)
	
func _on_characteristic_written(address, uuid):
	print("Characteristic written to ", address, ", UUID: ", uuid)

func _on_characteristic_write_error(error: String) -> void:
	print("Characteristic write error: ", error)
