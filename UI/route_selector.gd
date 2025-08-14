# RouteSelector.gd
extends AcceptDialog

signal route_chosen(idx : int)

@onready var container: VBoxContainer = $MarginContainer/VBoxContainer/RouteList

func set_routes(names: Array) -> void:
	# clean all the route
	for child in container.get_children():
		child.queue_free()
	# regenerate
	for i in range(names.size()):
		var btn = Button.new()
		btn.text = names[i]
		btn.pressed.connect(Callable(self, "_on_btn_pressed").bind(i))
		container.add_child(btn)


func _on_btn_pressed(idx: int) -> void:
	emit_signal("route_chosen", idx)
	hide()
