extends Component
class_name InteractHandler

const ItemType = ItemGlobals.ItemType
const ItemAction = ItemGlobals.ItemAction
const ITEM_DATA = ItemGlobals.ITEM_DATA

func get_component_name(): return "InteractHandler"

func get_focused_voxel(_active_voxel := true):
	return null

func frame_update(_delta: float):
	var inventory = entity.get_component("InventoryComponent")
	var current_item = inventory.current_item
	var items = inventory.items

	if Input.is_action_just_pressed("secondary_interact"):
		match ITEM_DATA[items[current_item].item_id]["action"]:
			ItemAction.PLACE:
				try_place_item()
			ItemAction.BULLDOZE:
				try_break_entity()
	
	var dci = int(Input.is_action_just_released("scroll_right")) - int(Input.is_action_just_released("scroll_left"))
	if dci != 0:
		inventory.current_item = (current_item + dci + items.size()) % items.size()

func try_place_item():
	var voxel_coords = get_focused_voxel(false)
	if voxel_coords == null: return
	
	var inventory = entity.get_component("InventoryComponent")
	var item_data = ITEM_DATA[inventory.get_current_item_object().item_id]
	assert(item_data["action"] == ItemAction.PLACE, "Trying to place item that is not placeable")
	
	var voxel_cost = item_data["cost"]
	if !inventory.has_item(ItemType.SCRAP, voxel_cost): 
		print("not enough scrap")
		return
	
	var voxel_manager = GameManager.voxel_manager
	var voxel_name = item_data["voxel_name"]
	if !voxel_manager.can_place_voxel(voxel_name, voxel_coords):
		print("can't place voxel there")
		return
	
	inventory.remove_item_by_id(ItemType.SCRAP, voxel_cost)

	var preview_component = entity.get_component("BlockPreviewComponent")
	var preview_rotation_y = preview_component.get_active_mesh().rotation.y
	voxel_manager.place_voxel(voxel_name, voxel_coords, preview_rotation_y)

func try_break_entity():
	var voxel_coords = get_focused_voxel(true)
	if voxel_coords == null: 
		return
	
	var voxel_manager = GameManager.voxel_manager
	if !voxel_manager.can_remove_entity(voxel_coords):
		print("can't remove that entity")
		return

	var inventory = entity.get_component("InventoryComponent")
	voxel_manager.remove_entity(voxel_coords)
	inventory.add_item(ItemType.SCRAP, 1)
