extends Panel

#this is where should input the texture of the item to the slot
@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_text: Label = $CenterContainer/Panel/Label
#if theres inventory item as a parameter, then show it in the slot by input the
#texture of the item into item_display
func update(slot: InvSlot):
	if !slot.item:
		item_visual.visible = false
		amount_text.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		if(slot.amount > 1):
			amount_text.visible = true
		amount_text.text = str(slot.amount)
