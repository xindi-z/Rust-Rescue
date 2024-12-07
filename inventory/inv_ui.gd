extends Control

@onready var inv: Inv = preload("res://inventory/playerinv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false


func _ready():
	update_slots()
	close()
	
func update_slots():
	for i in range(min(inv.creatures.size(),slots.size())):
		slots[i].update(inv.creatures[i])
	

func _process(dealta):
	if Input.is_action_just_pressed("i"): #add a button
		if is_open:
			close()
		else:
			open()

func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false
