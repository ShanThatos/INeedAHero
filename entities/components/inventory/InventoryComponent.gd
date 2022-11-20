extends Component
class_name InventoryComponent

const ItemType = ItemGlobals.ItemType
const ITEM_DATA = ItemGlobals.ITEM_DATA

var items: Array = []
var current_item: int = 0 setget set_current_item, get_current_item

signal _on_change_current_item(old_current_item, new_current_item)
signal _on_change_item(item_index)

func get_component_name(): return "InventoryComponent"

func start(_entity):
	var Item = load(FileUtils.find_script("Item", FileUtils.get_script_base_dir(self)))
	for _i in range(10):
		var item = Item.new()
		item.inventory = self
		item.set_to(ItemType.NONE, 0)
		items.append(item)
	

func set_current_item(new_current_item):
	var old_current_item = current_item
	current_item = new_current_item
	emit_signal("_on_change_current_item", old_current_item, new_current_item)

func get_current_item():
	return current_item

func get_current_item_object():
	return items[current_item]

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
		emit_signal("_on_change_item", final_index)
	return false

func remove_item_by_index(index: int, amount: int):
	assert(items[index].amount >= amount)
	items[index].amount -= amount
	if items[index].amount == 0:
		items[index].item_id = ItemType.NONE
	emit_signal("_on_change_item", index)

func remove_item_by_id(item_id: int, amount: int):
	for index in range(items.size()):
		if items[index].item_id == item_id:
			remove_item_by_index(index, amount)
			return

func _to_string():
	return "Inventory" + str(items)
