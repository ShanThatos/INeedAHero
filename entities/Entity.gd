extends Node
class_name Entity

var components: Array

func _ready():
	components = ArrayUtils.foreach(register_components(), "new")
	validate_components()
	if !GameManager.is_scene_loaded:
		yield(GameManager, "scene_loaded")
	ArrayUtils.foreach(components, funcref(self, "initiate_component"))
	start()

func validate_components():
	var names: Array = ArrayUtils.foreach(components, "get_component_name")
	for i in range(names.size() - 1):
		assert(names[i] != "", "Component name cannot be empty")
		assert(names.find(names[i]) == i, "Component name " + names[i] + " is not unique")

func initiate_component(component):
	component.entity = self
	if component.has_method("start"):
		component.start(self)

func get_component(component_name: String):
	for component in components:
		if component.get_component_name() == component_name:
			return component
	return null

func add_component(component):
	components.append(component)
	initiate_component(component)

func call_foreach_component(method_name: String, args: Array = []):
	for component in components:
		if component.enabled and component.has_method(method_name):
			component.callv(method_name, args)

func _physics_process(delta):
	call_foreach_component("physics_update", [self, delta])

func _process(delta):
	call_foreach_component("frame_update", [self, delta])

func _input(event):
	call_foreach_component("input_update", [self, event])



func start(): 
	pass

func register_components():
	return []
