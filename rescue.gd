extends Node

var ble_plugin
@onready var rescued_prompt: Window = $RescuedPrompt

func _ready():
	if Engine.has_singleton("BLEPlugin"):
		ble_plugin = Engine.get_singleton("BLEPlugin")
		print("BLE Plugin loaded successfully")

		ble_plugin.connect("device_found", Callable(self, "_on_device_found"))
		ble_plugin.connect("device_connected", Callable(self, "_on_device_connected"))
		ble_plugin.connect("device_disconnected", Callable(self, "_on_device_disconnected"))
		ble_plugin.connect("scan_failed", Callable(self, "_on_scan_failed"))
		ble_plugin.connect("characteristic_read", Callable(self, "_on_characteristic_read"))
		ble_plugin.connect("characteristic_changed", Callable(self, "_on_characteristic_changed"))
		ble_plugin.connect("characteristic_written", Callable(self, "_on_characteristic_written"))
		ble_plugin.connect("characteristic_write_error", Callable(self, "_on_characteristic_write_error"))

		ble_plugin.initialize()

		print("Starting Bluetooth scan...")
		ble_plugin.startScan()
	else:
		print("BLE Plugin not found!")

func _on_device_found(name, address):
	print("Device found: ", name, " (", address, ")")
	if name == "ForceSensorESP32":
		print("Target device found! Stopping scan and connecting...")
		ble_plugin.stopScan()
		ble_plugin.connectToDeviceByAddress(address)

func _on_device_connected(address, name):
	print("Connected to device: ", name, " (", address, ")")
	var keyuuid = "beb5483e-36e1-4688-b7f5-ea07361b26a8"
	
	# getting notification
	if ble_plugin.setCharacteristicNotifications(address, keyuuid, true):
		print("Enabled notifications for characteristic: ", keyuuid)
	else:
		print("Failed to enable notifications")

func _on_characteristic_changed(address, uuid, value):
	print("Characteristic changed from ", address, ", UUID: ", uuid, ", New Value: ", value)
	var str_value = value.get_string_from_utf8()
	if str_value == "a":
		print("recived the sensor value from blutooth：a")
		#when get the bluetooth signal, show prompt for message
		rescued_prompt.show_prompt()


func _on_device_disconnected(address, name):
	print("Disconnected from device: ", name, " (", address, ")")
func _on_scan_failed(error):
	print("Scan failed: ", error)

func _on_characteristic_read(address, uuid, value):
	print("Characteristic read from ", address, ", UUID: ", uuid, ", Value: ", value)
	
func _on_characteristic_written(address, uuid):
	print("Characteristic written to ", address, ", UUID: ", uuid)

func _on_characteristic_write_error(error: String) -> void:
	print("Characteristic write error: ", error)
