extends Spatial
class_name LevelManager

func _ready():
	name = "LevelManager"
	GameManager.level_manager = self

	var VoxelManager = load(FileUtils.find_script("VoxelManager"))
	var vm = VoxelManager.new()
	GameManager.voxel_manager = vm
	add_child(vm)

	vm.place_voxel("Base", Vector3(-2, 0, -2))


func get_level_scale() -> float:
	return scale.x

