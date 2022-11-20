extends Spatial
class_name VoxelManager


var voxels = {}


func _ready():
	name = "VoxelManager"

func global_to_voxel(global_pos: Vector3) -> Vector3:
	return to_local(global_pos).floor()

func get_voxel_at(voxel_pos: Vector3) -> Spatial:
	return voxels.get(voxel_pos, null)
func get_voxel_coord_for(voxel: Spatial) -> Vector3:
	return voxel.translation.floor()

func can_place_voxel(voxel_name: String, voxel_pos: Vector3) -> bool:
	if voxel_pos.y < 0:
		return false

	var voxel_size = VoxelGlobals.VOXEL_DATA[voxel_name]["size"]
	for dx in range(voxel_size.x):
		for dy in range(voxel_size.y):
			for dz in range(voxel_size.z):
				var test_position = voxel_pos + Vector3(dx, dy, dz)
				if test_position in voxels:
					return false
	return true

func place_voxel(voxel_name: String, voxel_pos: Vector3):
	assert(can_place_voxel(voxel_name, voxel_pos), "Cannot place entity at this position " + str(voxel_pos))

	var voxel_data: Dictionary = VoxelGlobals.VOXEL_DATA[voxel_name]
	var entity = voxel_data["scene"].instance() as Spatial
	entity.translation = voxel_pos

	entity.set_meta("voxel_name", voxel_name)
	for key in voxel_data:
		if key == "scene":
			continue
		entity.set_meta(key, voxel_data[key])

	add_child(entity)

	var voxel_size = voxel_data["size"]
	for dx in range(voxel_size.x):
		for dy in range(voxel_size.y):
			for dz in range(voxel_size.z):
				voxels[voxel_pos + Vector3(dx, dy, dz)] = entity

func can_remove_entity(voxel_pos: Vector3) -> bool:
	var voxel = get_voxel_at(voxel_pos)
	if voxel == null or !voxel.get_meta("breakable"):
		return false
	return true

func remove_entity(voxel_pos: Vector3):
	assert(can_remove_entity(voxel_pos), "Cannot remove entity at this position " + str(voxel_pos))

	var voxel = get_voxel_at(voxel_pos)
	var coords = get_voxel_coord_for(voxel)
	var voxel_size = voxel.get_meta("size")
	for dx in range(voxel_size.x):
		for dy in range(voxel_size.y):
			for dz in range(voxel_size.z):
				voxels.erase(coords + Vector3(dx, dy, dz))
	voxel.queue_free()

