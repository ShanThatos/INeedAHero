extends Entity
class_name ScrapTurret

export(float)   var max_health := 30.0
export(float)   var target_view_distance := 20.0

func start():
    pass

func register_components():
    var components := FileUtils.load_scripts(["HealthComponent"], "res://entities/components/")
    components.append_array(FileUtils.load_scripts(["ScrapTurretStateMachine"], FileUtils.get_script_base_dir(self)))
    return components

func can_see_target(target: Vector3):
    return true
