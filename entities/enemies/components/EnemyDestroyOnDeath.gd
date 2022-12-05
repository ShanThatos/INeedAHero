extends Component
class_name EnemyDestroyOnDeath

func get_component_name(): return "EnemyDestroyOnDeath"

func start():
    assert(entity.has_component("HealthComponent"), "EnemyDestroyOnDeath requires a HealthComponent")
    entity.get_component("HealthComponent").connect("_on_death", self, "_on_death")

func _on_death():
    print("Dropped ", entity.scrap_drop_amount, " scrap")
    entity.queue_free()