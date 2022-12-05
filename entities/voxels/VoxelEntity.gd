extends Entity
class_name VoxelEntity

export(bool) var health_component := false
export(float) var max_health := 0.0
export(bool) var destroy_on_death_component := false

func register_components():
	var generic_components = []
	if health_component:
		generic_components.append("HealthComponent")
	var voxel_components = []
	if destroy_on_death_component:
		voxel_components.append("VoxelDestroyOnDeath")

	var components := FileUtils.load_scripts(generic_components, "res://entities/components/")
	components.append_array(FileUtils.load_scripts(voxel_components, FileUtils.get_script_base_dir(self)))
	return components

func get_center():
	return self.translation + get_meta("size") / 2

func get_bottom_corners() -> Array:
	var size: Vector3 = get_meta("size")
	var corners = []
	corners.append(self.translation)
	corners.append(self.translation + Vector3(size.x, 0, 0))
	corners.append(self.translation + Vector3(0, 0, size.z))
	corners.append(self.translation + Vector3(size.x, 0, size.z))
	corners.append(get_center() + Vector3(size.x / 2, 0, 0))
	corners.append(get_center() + Vector3(0, 0, size.z / 2))
	corners.append(get_center() + Vector3(-size.x / 2, 0, 0))
	corners.append(get_center() + Vector3(0, 0, -size.z / 2))
	return corners
