extends Control

#inv is all the items.tres in the list
#slots are all the empty slots in the grid container
@onready var inv: Inv = preload("res://inventory/playerinv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var toggle_btn: Button = $"../../invButton"
@onready var rescued_prompt = get_node("/root/Main/CanvasLayer/HBoxContainer/rescue/RescuedPrompt")

#initilize for animal query
@onready var quiz_scene = preload("res://animal_quiz.tscn")
var quiz_instance: AcceptDialog

#intitial state
#updating creatures into the inventory slots
#hide the inventory
#if items are gathered, it will update slots
#item pic loaded as tres in right side of panel
@export var item: InvItem
#hide inventory at first
var is_open = false
# inv_ui.gd
@onready var total_label: Label = $NinePatchRect/total
func _ready():
#	listen to inv updates
	inv.update.connect(update_slots)
	update_slots()
	_update_total_label()

	close()
	
#when recived signal, call on_animal_rescued
	if rescued_prompt:
		print("Found RescuedPrompt node.")
		rescued_prompt.animal_rescued.connect(on_animal_rescued)
	else:
		print("RescuedPrompt node not found.")
		
#listen to inv button
	toggle_btn.pressed.connect(_on_ToggleButton_pressed)

#test by hotkey x
func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_X:
			on_animal_rescued()

func _update_total_label():
	if total_label:
		var n := inv.get_total_saved()
		total_label.text = "Saved creature: %d" % n

#adding creatures inventory(a list of the items's name and texture) into slots
func update_slots():
	for i in range(min(inv.slots.size(),slots.size())):
		slots[i].update(inv.slots[i])
	_update_total_label()

#actions could be operate during the game
#press i to open/close inventory
func _process(dealta):
	if Input.is_action_just_pressed("toggle_inventory"):
		_toggle_inventory()
		
#trigger in process to add creature into inventory
func _on_ToggleButton_pressed():
	_toggle_inventory()

func _toggle_inventory():
	if is_open:
		close()
	else:
		open()
		
func on_animal_rescued():
	print("Rescue signal received, collecting item...")
	collect(item)
	open()
	
func collect(item):
	inv.insert(item)
	_update_total_label()
	DialogueManager.show_dialogue_balloon(load("res://dialogs/gilamonster.dialogue"), "start")


func open():
	visible = true
	is_open = true

#need to add a button to close inventory
func close():
	visible = false
	is_open = false

func show_animal_quiz():
	if not quiz_instance:
		quiz_instance = quiz_scene.instantiate()
		add_child(quiz_instance)
	
	quiz_instance.show_quiz()
#call show_animal_quiz() to use
