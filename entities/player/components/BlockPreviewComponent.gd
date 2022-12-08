extends Component
class_name BlockPreviewComponent

const ItemType = ItemGlobals.ItemType
const ItemAction = ItemGlobals.ItemAction
const ITEM_DATA = ItemGlobals.ITEM_DATA

var preview_node_scene := preload("res://entities/voxels/voxelpreview/VoxelPreview.tscn")
var preview_node: Spatial
var tween: Tween
var meshes: Dictionary
var active_mesh_key: String

func get_component_name(): return "BlockPreviewComponent"

func start():
	preview_node = preview_node_scene.instance()
	tween = preview_node.get_node("Tween")
	GameManager.voxel_manager.add_child(preview_node)

	for mesh_name in ["Cube", "Ramp"]:
		meshes[mesh_name] = preview_node.get_node(mesh_name)
	active_mesh_key = "Cube"

func get_active_mesh():
	return meshes[active_mesh_key]

func frame_update(_delta: float):
	var inventory = entity.get_component("InventoryComponent")
	var item_id = inventory.get_current_item_object().item_id

	match ITEM_DATA[item_id]["action"]:
		ItemAction.PLACE:
			preview_voxel_placement(item_id)
		ItemAction.BULLDOZE:
			preview_voxel_break()
		_:
			preview_node.visible = false

func preview_voxel_placement(item_id: int):
	var interact_handler = entity.get_component("InteractHandler")
	var voxel_coords = interact_handler.get_focused_voxel(false)
	if voxel_coords == null: 
		preview_node.visible = false
		return

	var voxel_manager = GameManager.voxel_manager
	var item_data = ITEM_DATA[item_id]
	assert(item_data["action"] == ItemAction.PLACE)

	var voxel_name = item_data["voxel_name"]
	var voxel_data = VoxelGlobals.VOXEL_DATA[voxel_name]
	
	var inventory = entity.get_component("InventoryComponent")
	if !inventory.has_item(ItemType.SCRAP, item_data["cost"]):
		preview_node.visible = false
		return
	
	var mesh_name = voxel_data.get("mesh", "Cube")
	if mesh_name != active_mesh_key:
		get_active_mesh().visible = false
		active_mesh_key = mesh_name
	var active_mesh = get_active_mesh()
	active_mesh.visible = true

	tween.interpolate_property(preview_node, "scale", null, voxel_data["size"], .1)
	if preview_node.visible:
		tween.interpolate_property(preview_node, "translation", null, voxel_coords, .1)
	else:
		preview_node.translation = voxel_coords
	tween.start()

	var material: SpatialMaterial = active_mesh.get_surface_material(0)
	if voxel_manager.can_place_voxel(voxel_name, voxel_coords):
		material.albedo_color = Color(1, 1, 1, material.albedo_color.a)
	else:
		material.albedo_color = Color(1, 0, 0, material.albedo_color.a)

	preview_node.visible = true

func preview_voxel_break():
	var interact_handler = entity.get_component("InteractHandler")
	var focused_voxel_coords = interact_handler.get_focused_voxel(true)
	if focused_voxel_coords == null: 
		preview_node.visible = false
		return
	
	var voxel_manager = GameManager.voxel_manager
	var voxel_entity = voxel_manager.get_voxel_at(focused_voxel_coords)
	if voxel_entity == null or !voxel_entity.get_meta("breakable"):
		preview_node.visible = false
		return
	
	var voxel_coords = voxel_manager.get_voxel_coord_for(voxel_entity)
	tween.interpolate_property(preview_node, "scale", null, voxel_entity.get_meta("size"), .1)
	if preview_node.visible:
		tween.interpolate_property(preview_node, "translation", null, voxel_coords, .1)
	else:
		preview_node.translation = voxel_coords
	tween.start()

	get_active_mesh().visible = false
	active_mesh_key = "Cube"
	var active_mesh = get_active_mesh()
	active_mesh.visible = true

	var material: SpatialMaterial = active_mesh.get_surface_material(0)
	material.albedo_color = Color(1, 0, 0, material.albedo_color.a)
	active_mesh.set_surface_material(0, material)

	preview_node.visible = true

func input_update(event: InputEvent):
	if event.is_action_pressed("rotate_interact", true):
		get_active_mesh().rotate_y(PI / 2)
