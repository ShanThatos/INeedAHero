extends Component
class_name EnemyDestroyOnDeath

func get_component_name(): return "EnemyDestroyOnDeath"

func start():
    assert(entity.has_component("HealthComponent"), "EnemyDestroyOnDeath requires a HealthComponent")
    entity.get_component("HealthComponent").connect("_on_death", self, "_on_death")

func _on_death():
    GameManager.level_manager.player.get_component("InventoryComponent").add_item(ItemGlobals.ItemType.SCRAP, entity.scrap_drop_amount)
    entity.queue_free()