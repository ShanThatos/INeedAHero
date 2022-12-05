extends GenericState
class_name NavState


var nav_path: Array
var time_stuck: float

var astar_solver

func start():
	astar_solver = GameManager.nav_manager.AStarSolver.new()

func find_path_voxel(targets: Array):
	var targets_global = ArrayUtils.foreach(targets, funcref(GameManager.voxel_manager, "voxel_to_global"))
	nav_path = astar_solver.find_path_global(entity.global_translation, targets_global)
	time_stuck = 0

	# Gizmos.lifetime = 4.0
	# Gizmos.stroke = .1
	# Gizmos.color = Gizmos.RED
	# Gizmos.create_path(nav_path)

func follow_path(_delta: float):
	if has_finished_path():
		return

	var global_pos = entity.global_translation
	var closest_point_data = MathUtils.get_closest_point_on_path(global_pos, nav_path)
	var closest_point = closest_point_data[0]
	var segment_index = closest_point_data[1]

	var distance_to_point = global_pos.distance_to(closest_point)

	var level_scale = GameManager.level_manager.get_level_scale()

	var target
	if distance_to_point >= level_scale / 2:
		target = closest_point
	else:
		while segment_index > 0 and nav_path.size() > 2:
			nav_path.pop_front()
			segment_index -= 1
		target = nav_path[1]
	
	if has_finished_path():
		return
	
	var direction = MathUtils.get_xz_subvector(target - global_pos).normalized()
	var velocity = direction * entity.movement_speed * level_scale
	velocity.y -= entity.gravity * level_scale
	var body = entity as KinematicBody
	var previous_pos = body.global_translation
	body.move_and_slide(velocity, Vector3.UP)
	body.look_at(body.global_translation + direction, Vector3.UP)

	if previous_pos.is_equal_approx(body.global_translation):
		time_stuck += _delta
	else:
		time_stuck = 0

func has_finished_path():
	if nav_path == null or nav_path.size() < 2:
		return true
	var global_pos = entity.global_translation
	var level_scale = GameManager.level_manager.get_level_scale()
	if nav_path.size() == 2 and global_pos.distance_to(nav_path[1]) < level_scale / 2:
		nav_path = []
		return true
	return false

# Assums follow_path has been called every frame 
func is_stuck():
	return time_stuck > 1
