extends Component
class_name VoxelDestroyOnDeath

func get_component_name(): return "VoxelDestroyOnDeath"

func start():
    assert(entity.has_component("HealthComponent"), "VoxelDestroyOnDeath requires a HealthComponent")
    entity.get_component("HealthComponent").connect("_on_death", self, "_on_death")

func _on_death():
    GameManager.voxel_manager.remove_entity(entity.translation)