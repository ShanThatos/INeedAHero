extends Component
class_name InventoryDisplayComponent

const ITEM_DATA = ItemGlobals.ITEM_DATA

var item_slots: Array
var inventory

func get_component_name(): return "InventoryDisplay"

func start():
    item_slots = get_inventory_display().get_children()

    inventory = entity.get_component("InventoryComponent")
    inventory.connect("_on_change_current_item", self, "_on_change_current_item")
    inventory.connect("_on_change_item", self, "update_itemslot_display")
    inventory.current_item = inventory.current_item
    
    for i in range(10):
        update_itemslot_display(i)

func update_itemslot_display(item_index: int):
    var item_id = inventory.items[item_index].item_id
    var item_data = ITEM_DATA[item_id]
    
    var text_display: String = item_data.get("text_display", "")
    if "{cost}" in text_display:
        text_display = text_display.replace("{cost}", item_data["cost"])
    if "{amount}" in text_display:
        text_display = text_display.replace("{amount}", inventory.items[item_index].amount)
    item_slots[item_index].get_node("BottomLabel").text = text_display

    var texture_file_name = item_data.get("texture", "")
    var texture
    if texture_file_name != "":
        texture = load("res://entities/ui/items/" + texture_file_name)
    else:
        texture = null
    item_slots[item_index].get_node("ItemImage").texture = texture

func _on_change_current_item(old_item_index: int, new_item_index: int):
    item_slots[old_item_index].get_node("IsActive").visible = false
    item_slots[new_item_index].get_node("IsActive").visible = true

func input_update(event: InputEvent):
    if event is InputEventKey and event.is_pressed() and !event.echo:
        var num_key = event.unicode - 48
        if num_key >= 0 and num_key <= 9:
            if num_key == 0:
                num_key = 10
            entity.get_component("InventoryComponent").current_item = num_key - 1

func get_inventory_display():
    return GameManager.level_manager.get_node("./UI/InventoryDisplay")
