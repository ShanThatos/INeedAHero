extends Camera

export(float) var rot_speed = 1.0
export(float) var move_speed = 1.0
export(float) var delay = 1.0


var current_delay = 0.0

var turret_scene = preload("res://entities/turrets/ScrapTurret/ScrapTurret.tscn")
var grunt_scene = preload("res://entities/enemies/Grunt/Grunt.tscn")

func _ready():
	current_delay = delay

	# Gizmos.lifetime = 20.0
	# Gizmos.color = Gizmos.RED
	# Gizmos.stroke = .3
	# Gizmos.create_line(Vector3.FORWARD, Vector3.UP + Vector3.FORWARD)

	# if !GameManager.is_scene_loaded:
	# 	yield(GameManager, "scene_loaded")
	
	# Gizmos.color = Gizmos.YELLOW
	# Gizmos.create_line(Vector3.FORWARD, Vector3.UP + Vector3.FORWARD * 2)
	
	# if !GameManager.level_manager.is_level_manager_loaded:
	# 	yield(GameManager.level_manager, "level_manager_loaded")

	yield(get_tree().create_timer(20.0), "timeout")

	var lm = GameManager.level_manager
	
	# for angle in range(0, 360, 45):
	# 	var x = floor(cos(deg2rad(angle)) * 5 + .5)
	# 	var z = floor(sin(deg2rad(angle)) * 5 + .5)
	# 	if GameManager.voxel_manager.can_place_voxel("ScrapTurret", Vector3(x, 0, z)):
	# 		GameManager.voxel_manager.place_voxel("ScrapTurret", Vector3(x, 0, z))
	
	for angle in range(0, 360, 20):
		var grunt: Spatial = grunt_scene.instance()
		lm.add_child(grunt)
		var x = cos(deg2rad(angle)) * 20 + .5
		var z = sin(deg2rad(angle)) * 20 + .5
		grunt.global_translation = lm.to_global(Vector3(x, 0, z))
	
	# for angle in range(10, 370, 20):
	# 	var grunt: Spatial = grunt_scene.instance()
	# 	lm.add_child(grunt)
	# 	var x = cos(deg2rad(angle)) * 12 + .5
	# 	var z = sin(deg2rad(angle)) * 12 + .5
	# 	grunt.global_translation = lm.to_global(Vector3(x, 0, z))




func _physics_process(delta: float):
	if current_delay > 0:
		current_delay -= delta
		return

	rotate_y(rot_speed * delta)
	global_translate(Vector3.FORWARD * move_speed * delta)

