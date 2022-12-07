extends InventoryDisplayComponent
class_name VRInventoryDisplay


func get_inventory_display():
	return GameManager.get_meta("vr_inventory")
