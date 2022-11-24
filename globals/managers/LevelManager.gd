extends Spatial
class_name LevelManager

var base_entity

func _ready():
	name = "LevelManager"
	GameManager.level_manager = self

	var VoxelManager = load(FileUtils.find_script("VoxelManager", FileUtils.get_script_base_dir(self)))
	add_child(VoxelManager.new())

	var NavManager = load(FileUtils.find_script("NavManager", FileUtils.get_script_base_dir(self)))
	add_child(NavManager.new())

	base_entity = GameManager.voxel_manager.place_voxel("Base", Vector3(-1, 0, -1))
	for x in range(-2, 3):
		for z in range(-2, 3):
			if GameManager.voxel_manager.can_place_voxel("ScrapBlock", Vector3(x, 0, z)):
				GameManager.voxel_manager.place_voxel("ScrapBlock", Vector3(x, 0, z))

func get_level_scale() -> float:
	return scale.x

