extends Spatial
class_name LevelManager

func _ready():
	name = "LevelManager"
	GameManager.level_manager = self

	var VoxelManager = load(FileUtils.find_script("VoxelManager", FileUtils.get_script_base_dir(self)))
	add_child(VoxelManager.new())

	var NavManager = load(FileUtils.find_script("NavManager", FileUtils.get_script_base_dir(self)))
	add_child(NavManager.new())

	GameManager.voxel_manager.place_voxel("Base", Vector3(-2, 0, -2))

func get_level_scale() -> float:
	return scale.x

