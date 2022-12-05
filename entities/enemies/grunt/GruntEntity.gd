extends EnemyEntity
class_name GruntEntity

export(float) 	var movement_speed := 2.0
export(float) 	var gravity := 10.0
export(float)	var attack_cooldown := 1.0

var animator: AnimationPlayer
var target_zone: Area

func start():
	animator = $Animator
	target_zone = $TargetZone

func register_components():
	var components = .register_components()
	components.append_array(FileUtils.load_scripts(["GruntStateMachine"], FileUtils.get_script_base_dir(self)))
	return components
