class_name ExportUtils

static func make_property(prop: String, prop_type: int):
	return {
		name = prop,
		type = prop_type,
	}

static func make_properties_list(props: Array, prop_type: int):
	var EU = load(FileUtils.find_script("ExportUtils"))
	return ArrayUtils.foreach(props, funcref(EU, "make_property"), [prop_type])

static func extract_export_vars(packed_scene: PackedScene) -> Dictionary:
	var scene_state := packed_scene.get_state()
	var properties = {}
	for i in range(scene_state.get_node_property_count(0)):
		properties[scene_state.get_node_property_name(0, i)] = scene_state.get_node_property_value(0, i)
	return properties
