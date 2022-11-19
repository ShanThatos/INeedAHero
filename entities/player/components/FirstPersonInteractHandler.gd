extends Component
class_name FirstPersonInteractHandler

const ItemType = ItemGlobals.ItemType
const ItemAction = ItemGlobals.ItemAction
const ITEM_DATA = ItemGlobals.ITEM_DATA

func get_component_name(): return "InteractHandler"

func get_focused_voxel(active_voxel := true):
	var raycast: RayCast = entity.get_component("FirstPersonController").forwardRayCast
	if raycast.is_colliding():
		var scale_multiplier = GameManager.level_manager.get_level_scale()
		var direction_mul = -.1 if active_voxel else 1.0
		var voxel_coords = GameManager.voxel_manager.global_to_voxel(raycast.get_collision_point() + raycast.get_collision_normal().normalized() * scale_multiplier * .9 * direction_mul)
		return voxel_coords
	return null

func frame_update(entity: PlayerEntity, _delta: float):
	var inventory = entity.get_component("InventoryComponent")
	var current_item = inventory.current_item
	var items = inventory.items

	if Input.is_action_just_pressed("secondary_interact"):
		if current_item < items.size():
			match ITEM_DATA[items[current_item].item_id]["action"]:
				ItemAction.PLACE:
					try_place_item()
				ItemAction.BULLDOZE:
					try_break_entity()
	
	var dci = int(Input.is_action_just_released("scroll_right")) - int(Input.is_action_just_released("scroll_left"))
	if dci != 0:
		inventory.current_item = (current_item + dci + items.size()) % items.size()

func try_place_item():
	var inventory = entity.get_component("InventoryComponent")
	var current_item = inventory.current_item
	var items = inventory.items

	var voxel_coords = get_focused_voxel(false)
	if voxel_coords == null: return
	
	var voxel_manager = GameManager.voxel_manager
	var item_id = items[current_item].item_id
	var item_entity_scene = voxel_manager.find_entity_scene(item_id)
	
	if item_entity_scene == null:
		print("ERROR: No entity scene for item " + str(item_id))
		return
	if !voxel_manager.can_place_entity(item_entity_scene, voxel_coords):
		print("can't place entity there")
		return
	if !inventory.has_item(ItemType.SCRAP, ITEM_DATA[item_id]["cost"]):
		print("not enough scrap")
		return

	inventory.remove_item_by_id(ItemType.SCRAP, ITEM_DATA[item_id]["cost"])
	voxel_manager.place_entity(item_entity_scene, voxel_coords)

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
