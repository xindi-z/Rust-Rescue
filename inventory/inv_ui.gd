extends Control

#inv is all the items.tres in the list
#slots are all the empty slots in the grid container
@onready var inv: Inv = preload("res://inventory/playerinv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

#item pic loaded as tres in right side of panel
@export var item: InvItem
#hide inventory at first
var is_open = false

#intitial state
#updating creatures into the inventory slots
#hide the inventory
#connect the update singal to the function update_slots
#if items are gathered, it will update slots
func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()

#adding creatures inventory(a list of the items's name and texture) into slots
func update_slots():
	for i in range(min(inv.slots.size(),slots.size())):
		slots[i].update(inv.slots[i])
	
#actions could be operate during the game
#press i to open/close inventory, should add a button to operate in phone 
func _process(dealta):
	if Input.is_action_just_pressed("i"): #add a button
		if is_open:
			close()
		else:
			open()
	if Input.is_action_just_pressed("x"):
		collect(item)
#trigger in process to add creature into inventory
#where this item come from? how should i set it
#item should be stright pass to the function after sensor is pressed
#after colleted, plot should shown(a simple story of specis background)


func collect(item):
	inv.insert(item)



func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false
