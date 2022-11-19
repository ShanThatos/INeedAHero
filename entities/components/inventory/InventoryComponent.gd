extends Component
class_name InventoryComponent

const ItemType = ItemGlobals.ItemType
const ITEM_DATA = ItemGlobals.ITEM_DATA

var items: Array = []
var current_item: int = 0 setget set_current_item, get_current_item

func get_component_name(): return "InventoryComponent"

func start(_entity):
	var Item = load(FileUtils.find_script("Item"))
	for i in range(10):
		var item = Item.new()
		item.inventory = self
		item.set_to(ItemType.NONE, 0)
		items.append(item)
		update_itemslot_display(i)
	
	GameManager.level_manager.inventory_slots.get_child(0).get_node("IsActive").visible = true

func set_current_item(new_current_item):
	GameManager.level_manager.inventory_slots.get_child(current_item).get_node("IsActive").visible = false
	current_item = new_current_item
	GameManager.level_manager.inventory_slots.get_child(current_item).get_node("IsActive").visible = true

func get_current_item():
	return current_item

func has_item(item_id: int, amount: int) -> bool:
	for item in items:
		if item.item_id == item_id and item.amount >= amount:
			return true
	return false

func add_item(item_id: int, amount: int) -> bool:
	var final_index = -1
	for index in range(items.size()):
		var item = items[index]
		if item.item_id == item_id:
			item.amount += amount
			final_index = index
			break
	if final_index == -1:
		for index in range(items.size()):
			var item = items[index]
			if item.item_id == ItemType.NONE:
				item.set_to(item_id, amount)
				final_index = index
				break
	if final_index != -1:
		update_itemslot_display(final_index)
	return false

func remove_item_by_index(index: int, amount: int):
	assert(items[index].amount >= amount)
	items[index].amount -= amount
	if items[index].amount == 0:
		items[index].item_id = ItemType.NONE
	update_itemslot_display(index)

func remove_item_by_id(item_id: int, amount: int):
	for index in range(items.size()):
		if items[index].item_id == item_id:
			remove_item_by_index(index, amount)
			return

func update_itemslot_display(index: int):
	# if !GameManager.level_manager:
	# 	return
	
	var item_id = items[index].item_id
	var text_display: String = ITEM_DATA[item_id].get("text_display", "")
	if "{cost}" in text_display:
		text_display = text_display.replace("{cost}", ITEM_DATA[item_id]["cost"])
	if "{amount}" in text_display:
		text_display = text_display.replace("{amount}", items[index].amount)
	GameManager.level_manager.inventory_slots.get_child(index).get_node("CostLabel").text = text_display

	var texture_file_name = ITEM_DATA[item_id].get("texture", "")
	var texture
	if texture_file_name != "":
		texture = load("res://entities/ui/items/" + texture_file_name)
	else:
		texture = null
	GameManager.level_manager.inventory_slots.get_child(index).get_node("ItemImage").texture = texture

func _to_string():
	return "Inventory" + str(items)
