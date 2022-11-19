extends Entity
class_name GruntEntity

export(float) 	var max_health: float = 30


func start():
	pass


func register_components():
	var components := FileUtils.load_scripts(["HealthComponent"], "res://entities/components/")
	components.append_array(FileUtils.load_scripts(["GruntStateMachine"], FileUtils.get_script_base_dir(self)))
	return components
