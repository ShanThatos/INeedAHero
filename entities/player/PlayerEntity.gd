extends Entity
class_name PlayerEntity

const ItemType = ItemGlobals.ItemType

export(float) 	var max_speed: float = 10
export(float) 	var movement_acceleration: float = 10
export(float) 	var deceleration_rate: float = 10
export(float) 	var gravity_acceleration: float = 10
export(float) 	var horiz_rotation_speed: float = 10
export(float) 	var vert_rotation_speed: float = 10
export(float) 	var max_x_rotation: float = 89
export(float) 	var min_x_rotation: float = -89

export(float) 	var max_health: float = 100

var velocity: Vector3 = Vector3.ZERO
var mouse_delta: Vector2 = Vector2.ZERO

func start():
	var inventory = get_component("InventoryComponent")
	inventory.add_item(ItemType.SCRAP, 100)
	inventory.add_item(ItemType.BULLDOZER, 1)
	inventory.add_item(ItemType.SCRAP_BLOCK, 1)
	inventory.add_item(ItemType.SCRAP_RAMP, 1)

func register_components():
	var components := FileUtils.load_scripts(["HealthComponent", "InventoryComponent", "InventoryDisplayComponent"], "res://entities/components/")
	components.append_array(FileUtils.load_scripts(["BlockPreviewComponent", "FirstPersonController", "FirstPersonInteractHandler"], FileUtils.get_script_base_dir(self)))
	return components
