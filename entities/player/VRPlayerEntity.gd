extends Entity
class_name VRPlayerEntity

const ItemType = ItemGlobals.ItemType

func start():
	var inventory = get_component("InventoryComponent")
	inventory.add_item(ItemType.SCRAP_BLOCK, 1)
	inventory.add_item(ItemType.SCRAP, 100)
	inventory.add_item(ItemType.BULLDOZER, 1)
	inventory.add_item(ItemType.SCRAP_RAMP, 1)

func register_components():
	var components := FileUtils.load_scripts(["InventoryComponent"], "res://entities/components/")
	components.append_array(FileUtils.load_scripts(["BlockPreviewComponent", "VRInteractHandler"], FileUtils.get_script_base_dir(self)))
	return components
