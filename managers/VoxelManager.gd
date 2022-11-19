extends Spatial
class_name VoxelManager


var voxels = {}


func _ready():
	name = "VoxelManager"

var __cached_entity_scenes = {}
func find_entity_scene(entity_type: int):
	if entity_type in __cached_entity_scenes:
		return __cached_entity_scenes[entity_type]
	for voxel_entity in VoxelEntities.entity_scenes:
		var props := ExportUtils.extract_export_vars(voxel_entity)
		if props.get("entity_type", 0) == entity_type:
			__cached_entity_scenes[entity_type] = voxel_entity
			return voxel_entity
	__cached_entity_scenes[entity_type] = null
	return null

func global_to_voxel(global_pos: Vector3) -> Vector3:
	return to_local(global_pos).floor()

func get_voxel_at(voxel_pos: Vector3) -> VoxelEntity:
	return voxels.get(voxel_pos, null)
func get_voxel_coord_for(voxel: Spatial) -> Vector3:
	return voxel.translation.floor()

func can_place_entity(entity_scene: PackedScene, voxel_pos: Vector3) -> bool:
	if voxel_pos.y < 0:
		return false
	var properties = ExportUtils.extract_export_vars(entity_scene)
	var voxel_size = properties["voxel_size"]
	for dx in range(voxel_size.x):
		for dy in range(voxel_size.y):
			for dz in range(voxel_size.z):
				var test_position = voxel_pos + Vector3(dx, dy, dz)
				if test_position in voxels:
					return false
	return true

func place_entity(entity_scene: PackedScene, voxel_pos: Vector3):
	assert(can_place_entity(entity_scene, voxel_pos), "Cannot place entity at this position " + str(voxel_pos))

	var entity = entity_scene.instance() as Spatial
	entity.translation = voxel_pos
	add_child(entity)

	var properties = ExportUtils.extract_export_vars(entity_scene)
	var voxel_size = properties["voxel_size"]
	for dx in range(voxel_size.x):
		for dy in range(voxel_size.y):
			for dz in range(voxel_size.z):
				voxels[voxel_pos + Vector3(dx, dy, dz)] = entity

func can_remove_entity(voxel_pos: Vector3) -> bool:
	var voxel = get_voxel_at(voxel_pos)
	if voxel == null or !voxel.breakable:
		return false
	return true

func remove_entity(voxel_pos: Vector3):
	assert(can_remove_entity(voxel_pos), "Cannot remove entity at this position " + str(voxel_pos))

	var voxel = get_voxel_at(voxel_pos)
	var coords = get_voxel_coord_for(voxel)
	var voxel_size = voxel.voxel_size
	for dx in range(voxel_size.x):
		for dy in range(voxel_size.y):
			for dz in range(voxel_size.z):
				voxels.erase(coords + Vector3(dx, dy, dz))
	voxel.queue_free()

