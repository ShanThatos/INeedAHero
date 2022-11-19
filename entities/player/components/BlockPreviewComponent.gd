extends Component
class_name BlockPreviewComponent

const ItemType = ItemGlobals.ItemType
const ItemAction = ItemGlobals.ItemAction
const ITEM_DATA = ItemGlobals.ITEM_DATA

var preview_node_scene := preload("res://entities/voxels/voxelpreview/VoxelPreview.tscn")
var preview_node: Spatial
var tween: Tween
var mesh_instance: MeshInstance

func get_component_name(): return "BlockPreviewComponent"

func start(_entity):
	preview_node = preview_node_scene.instance()
	tween = preview_node.get_node("Tween")
	mesh_instance = preview_node.get_node("MeshInstance")
	GameManager.voxel_manager.add_child(preview_node)

func frame_update(entity: PlayerEntity, _delta: float):
	var inventory = entity.get_component("InventoryComponent")
	var current_item = inventory.current_item
	var items = inventory.items
	var item_id = items[current_item].item_id

	if ITEM_DATA[item_id]["action"] == ItemAction.PLACE:
		preview_voxel_placement(item_id)
	elif ITEM_DATA[item_id]["action"] == ItemAction.BULLDOZE:
		preview_voxel_break()
	else:
		preview_node.visible = false

func preview_voxel_placement(item_id: int):
	var interact_handler = entity.get_component("InteractHandler")
	var voxel_coords = interact_handler.get_focused_voxel(false)
	if voxel_coords == null: 
		preview_node.visible = false
		return

	var voxel_manager = GameManager.voxel_manager
	var item_entity_scene = voxel_manager.find_entity_scene(item_id)
	if (item_entity_scene == null):
		preview_node.visible = false
		return
	
	var inventory = entity.get_component("InventoryComponent")
	if !inventory.has_item(ItemType.SCRAP, ITEM_DATA[item_id]["cost"]):
		preview_node.visible = false
		return

	var properties = ExportUtils.extract_export_vars(item_entity_scene)
	var voxel_size = properties["voxel_size"]
	
	var _ignore = tween.interpolate_property(preview_node, "scale", null, voxel_size, .1)
	if preview_node.visible:
		_ignore = tween.interpolate_property(preview_node, "translation", null, voxel_coords, .1)
	else:
		preview_node.translation = voxel_coords
	_ignore = tween.start()

	var material: SpatialMaterial = mesh_instance.get_surface_material(0)
	if voxel_manager.can_place_entity(item_entity_scene, voxel_coords):
		material.albedo_color = Color(1, 1, 1, material.albedo_color.a)
	else:
		material.albedo_color = Color(1, 0, 0, material.albedo_color.a)
	mesh_instance.set_surface_material(0, material)

	preview_node.visible = true

func preview_voxel_break():
	var interact_handler = entity.get_component("InteractHandler")
	var focused_voxel_coords = interact_handler.get_focused_voxel(true)
	if focused_voxel_coords == null: 
		preview_node.visible = false
		return
	
	var voxel_manager = GameManager.voxel_manager
	var voxel_entity: VoxelEntity = voxel_manager.get_voxel_at(focused_voxel_coords)
	if voxel_entity == null:
		preview_node.visible = false
		return
	var voxel_size = voxel_entity.voxel_size
	var voxel_coords = voxel_manager.get_voxel_coord_for(voxel_entity)

	var _ignore = tween.interpolate_property(preview_node, "scale", null, voxel_size, .1)
	if preview_node.visible:
		_ignore = tween.interpolate_property(preview_node, "translation", null, voxel_coords, .1)
	else:
		preview_node.translation = voxel_coords
	_ignore = tween.start()

	var material: SpatialMaterial = mesh_instance.get_surface_material(0)
	material.albedo_color = Color(1, 0, 0, material.albedo_color.a)
	mesh_instance.set_surface_material(0, material)

	preview_node.visible = true

