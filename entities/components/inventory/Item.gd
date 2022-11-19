class_name Item

const ItemGlobals = preload("res://globals/ItemGlobals.gd")
const ItemType = ItemGlobals.ItemType
const ITEM_DATA = ItemGlobals.ITEM_DATA

var inventory = null
var item_id: int
var amount: int

func set_to(_item_id: int, _amount: int):
	item_id = _item_id
	amount = _amount

func _to_string():
	return "Item[%s, %d]" % [ITEM_DATA[item_id].name, amount]
