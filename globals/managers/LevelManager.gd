extends Spatial
class_name LevelManager

var grunt_enemy_scene = preload("res://entities/enemies/Grunt/Grunt.tscn")

var player
var ground
var base_entity

var spawn_timer = 0
var wave = 0

var is_level_manager_loaded = false
signal level_manager_loaded

func _ready():
	name = "LevelManager"
	GameManager.level_manager = self

	var VoxelManager = load(FileUtils.find_script("VoxelManager", FileUtils.get_script_base_dir(self)))
	add_child(VoxelManager.new())

	var NavManager = load(FileUtils.find_script("NavManager", FileUtils.get_script_base_dir(self)))
	add_child(NavManager.new())

	base_entity = GameManager.voxel_manager.place_voxel("Base", Vector3(-1, 0, -1))
	ground = get_node("Ground")

	is_level_manager_loaded = true
	emit_signal("level_manager_loaded")

	spawn_timer = 10.0

func get_level_scale() -> float:
	return scale.x

func get_ground_corners() -> Array:
	var ground_width = ground.scale.x
	var ground_length = ground.scale.z
	return [
		Vector3(-ground_width / 2, 0, -ground_length / 2),
		Vector3(ground_width / 2, 0, -ground_length / 2),
		Vector3(ground_width / 2, 0, ground_length / 2),
		Vector3(-ground_width / 2, 0, ground_length / 2)
	]

var __spawn_points_cache = null
func get_spawn_points() -> Array:
	if __spawn_points_cache != null:
		return __spawn_points_cache
	
	var spawn_points = []
	var ground_corners = get_ground_corners()
	spawn_points.append_array(ground_corners)

	for i in range(4):
		var corner = ground_corners[i]
		var next_corner = ground_corners[(i + 1) % 4]
		var corner_to_next_corner = next_corner - corner
		var corner_to_next_corner_length = corner_to_next_corner.length()
		var corner_to_next_corner_unit = corner_to_next_corner.normalized()
		var spawn_point_count = floor(corner_to_next_corner_length)
		for j in range(1, spawn_point_count):
			var spawn_point = corner + corner_to_next_corner_unit * j
			spawn_point -= spawn_point.normalized() * get_level_scale() * .5
			spawn_points.append(spawn_point)

	__spawn_points_cache = spawn_points
	return spawn_points

func _physics_process(delta: float):
	
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_timer = 20.0
		spawn_wave()

func spawn_wave():
	wave += 1
	var spawn_count = floor(pow(wave, .9) + 1)
	var spawn_points = get_spawn_points()
	for _i in range(spawn_count):
		yield(get_tree().create_timer(0.01), "timeout")
		if !is_instance_valid(self):
			break
		var enemy = grunt_enemy_scene.instance()
		add_child(enemy)
		
		var spawn_point = spawn_points[randi() % spawn_points.size()]
		enemy.global_translation = to_global(spawn_point)
