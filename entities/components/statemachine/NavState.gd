extends GenericState
class_name NavState

var movement_speed: float = 2.0
var gravity: float = 10
var nav_path: Array

func find_path(target):
	nav_path = GameManager.nav_manager.find_path_global(entity.global_transform.origin, target)

	if nav_path != null:
		Gizmos.color = Gizmos.RED
		Gizmos.lifetime = 3
		var path_node = Gizmos.create_path(nav_path)
		path_node.translation.y += GameManager.level_manager.get_level_scale()

func follow_path(_delta: float):
	var global_pos = entity.global_transform.origin
	var closest_point_data = MathUtils.get_closest_point_on_path(global_pos, nav_path)
	var closest_point = closest_point_data[0]
	var segment_index = closest_point_data[1]

	var distance_to_point = global_pos.distance_to(closest_point)

	var target
	if distance_to_point >= .5:
		target = closest_point
	else:
		while segment_index > 0 and nav_path.size() > 0:
			nav_path.pop_front()
			segment_index -= 1
		target = nav_path[(segment_index + 1) % nav_path.size()]
	
	var direction = (target - global_pos).normalized()
	var level_scale = GameManager.level_manager.get_level_scale()
	var velocity = direction * movement_speed * level_scale
	velocity.y -= gravity * level_scale
	var body = entity as KinematicBody
	body.move_and_slide(velocity, Vector3.UP)

