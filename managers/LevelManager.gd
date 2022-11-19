extends Spatial
class_name LevelManager

onready var inventory_slots = $UI/InventorySlots

func _ready():
	name = "LevelManager"
	GameManager.level_manager = self

	var VoxelManager = load(FileUtils.find_script("VoxelManager"))
	var vm = VoxelManager.new()
	GameManager.voxel_manager = vm
	add_child(vm)

	vm.place_entity(vm.find_entity_scene(ItemGlobals.ItemType.BASE), Vector3(-2, 0, -2))


func get_level_scale() -> float:
	return scale.x

