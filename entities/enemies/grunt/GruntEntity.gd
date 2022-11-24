extends Entity
class_name GruntEntity

export(float) 	var max_health := 30.0
export(float) 	var movement_speed := 2.0
export(float) 	var gravity := 10.0
export(float)	var attack_cooldown := 1.0

onready var animator: AnimationPlayer = $Animator
onready var target_zone: Area = $TargetZone

func start():
	pass

func register_components():
	var components := FileUtils.load_scripts(["HealthComponent"], "res://entities/components/")
	components.append_array(FileUtils.load_scripts(["GruntStateMachine"], FileUtils.get_script_base_dir(self)))
	return components
