extends Resource

#class Inv has property of slots wich contains a list of items(name, texture,amount)
class_name Inv
signal update
@export var slots: Array[InvSlot]


func insert(item: InvItem):
	print("Inserting item:", item.name)
	var itemslots = slots.filter(func(slot): return slot.item == item)
	print("Matching slots:", itemslots.size())
	if !itemslots.is_empty():
		itemslots[0].amount += 1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		print("Empty slots:", emptyslots.size())
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
	update.emit()

# Inv.gd
func get_total_saved() -> int:
	var total := 0
	for s in slots:
		if s.item != null:
			total += max(0, s.amount)
	return total
