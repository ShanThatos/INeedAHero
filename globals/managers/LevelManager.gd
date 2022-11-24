extends Spatial
class_name LevelManager

var base_entity

func _ready():
	name = "LevelManager"
	GameManager.level_manager = self

	var level_scale = get_level_scale()
	var ydiff = Vector3.UP * level_scale
	var xdiff = Vector3.RIGHT * level_scale
	Gizmos.lifetime = 20.0
	Gizmos.color = Gizmos.RED
	Gizmos.create_line(global_translation, global_translation + ydiff * 3)
	Gizmos.color = Gizmos.YELLOW

	print(FileUtils.get_script_base_dir(self))
	Gizmos.create_line(global_translation, global_translation + ydiff * 10)

	print(FileUtils.find_script("VoxelManager", FileUtils.get_script_base_dir(self)))
	Gizmos.create_line(global_translation, global_translation + ydiff * 20)

	print(load(FileUtils.find_script("VoxelManager", FileUtils.get_script_base_dir(self))))
	Gizmos.create_line(global_translation, global_translation + ydiff * 30)

	var VoxelManager = load(FileUtils.find_script("VoxelManager", FileUtils.get_script_base_dir(self)))
	add_child(VoxelManager.new())

	Gizmos.create_line(global_translation + xdiff * 4, global_translation + ydiff * 3 + xdiff * 4)

	var NavManager = load(FileUtils.find_script("NavManager", FileUtils.get_script_base_dir(self)))
	add_child(NavManager.new())

	Gizmos.create_line(global_translation + xdiff * 5, global_translation + ydiff * 3 + xdiff * 5)

	base_entity = GameManager.voxel_manager.place_voxel("Base", Vector3(-1, 0, -1))
	for x in range(-2, 3):
		for z in range(-2, 3):
			if GameManager.voxel_manager.can_place_voxel("ScrapBlock", Vector3(x, 0, z)):
				GameManager.voxel_manager.place_voxel("ScrapBlock", Vector3(x, 0, z))
	Gizmos.create_line(global_translation + xdiff * 6, global_translation + ydiff * 3 + xdiff * 6)

func get_level_scale() -> float:
	return scale.x

