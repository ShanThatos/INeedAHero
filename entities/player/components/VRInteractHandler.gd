extends InteractHandler
class_name VRInteractHandler

func get_focused_voxel(active_voxel := true):
	var vm = GameManager.voxel_manager
	var thumb_pos = GameManager.get_meta("right_thumb_tip").global_translation
	var index_pos = GameManager.get_meta("right_index_tip").global_translation
	var target_pos = (thumb_pos + index_pos) / 2 + Vector3.DOWN * .01
	var voxel_coords = vm.global_to_voxel(target_pos)
	if active_voxel and vm.get_voxel_at(voxel_coords) == null:
		return null
	return voxel_coords

func frame_update(_delta: float):
	var thumb_pos = GameManager.get_meta("right_thumb_tip").global_translation
	var index_pos = GameManager.get_meta("right_index_tip").global_translation

	if thumb_pos.distance_to(index_pos) < .015:
		if !Input.is_action_pressed("secondary_interact"):
			var a = InputEventAction.new()
			a.action = "secondary_interact"
			a.pressed = true
			Input.parse_input_event(a)
	elif Input.is_action_pressed("secondary_interact"):
		var a = InputEventAction.new()
		a.action = "secondary_interact"
		a.pressed = false
		Input.parse_input_event(a)

	.frame_update(_delta)


