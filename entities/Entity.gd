extends Node
class_name Entity

var components: Array

func _ready():
	components = ArrayUtils.foreach(register_components(), "new")
	validate_components()
	if !GameManager.is_scene_loaded:
		yield(GameManager, "scene_loaded")
	ArrayUtils.foreach(components, "set", ["entity", self])
	ArrayUtils.foreach(components, "start", [], true)
	start()

	var bodies = NodeUtils.get_all_children_with_type(self, PhysicsBody)
	for body in bodies:
		body.set_meta("entity", self)

func validate_components():
	var names: Array = ArrayUtils.foreach(components, "get_component_name")
	for i in range(names.size() - 1):
		assert(names[i] != "", "Component name cannot be empty")
		assert(names.find(names[i]) == i, "Component name " + names[i] + " is not unique")

func get_component(component_name: String):
	for component in components:
		if component.get_component_name() == component_name:
			return component
	return null

func has_component(component_name: String):
	return get_component(component_name) != null

func _physics_process(delta):
	ArrayUtils.foreach(components, "physics_update", [delta], true)

func _process(delta):
	ArrayUtils.foreach(components, "frame_update", [delta], true)

func _input(event):
	ArrayUtils.foreach(components, "input_update", [event], true)



func start(): 
	pass

func register_components():
	return []
