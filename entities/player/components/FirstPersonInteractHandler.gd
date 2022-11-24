extends InteractHandler
class_name FirstPersonInteractHandler

func get_focused_voxel(active_voxel := true):
	var raycast: RayCast = entity.get_component("FirstPersonController").forward_ray_cast
	if raycast.is_colliding():
		var scale_multiplier = GameManager.level_manager.get_level_scale()
		var direction_mul = -.1 if active_voxel else 1.0
		var voxel_coords = GameManager.voxel_manager.global_to_voxel(raycast.get_collision_point() + raycast.get_collision_normal().normalized() * scale_multiplier * .9 * direction_mul)
		return voxel_coords
	return null
