extends Entity
class_name EnemyEntity

export(float) 	var max_health := 30.0
export(bool)    var destroy_on_death_component := true
export(int)     var scrap_drop_amount := 1

func register_components():
	var components := FileUtils.load_scripts(["HealthComponent"], "res://entities/components/")
	if destroy_on_death_component:
		components.append_array(FileUtils.load_scripts(["EnemyDestroyOnDeath"], "res://entities/enemies/components/"))
	return components
