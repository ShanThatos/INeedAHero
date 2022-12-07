extends Entity
class_name VRPlayerEntity

const ItemType = ItemGlobals.ItemType

func start():
	GameManager.level_manager.player = self
	var inventory = get_component("InventoryComponent")
	inventory.add_item(ItemType.SCRAP, 10)
	inventory.add_item(ItemType.BULLDOZER, 1)
	inventory.add_item(ItemType.SCRAP_BLOCK, 1)
	inventory.add_item(ItemType.SCRAP_TURRET, 1)

func register_components():
	var components := FileUtils.load_scripts(["InventoryComponent"], "res://entities/components/")
	components.append_array(FileUtils.load_scripts(["BlockPreviewComponent", "VRInteractHandler", "VRInventoryDisplay"], FileUtils.get_script_base_dir(self)))
	return components
