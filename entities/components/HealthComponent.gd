extends Component
class_name HealthComponent

var current_health: float
var is_invincible := false
var is_dead := false
var health_bars: Array

signal _on_regen
signal _on_take_damage
signal _on_death

func get_component_name(): return "HealthComponent"

func start():
	assert("max_health" in entity, "Entity must have a max_health property")
	assert(entity.max_health > 0.0, "Max health must be greater than 0")
	current_health = entity.max_health

	health_bars = NodeUtils.get_all_children_with_type(entity, HealthBar)

func regen_health(amount: float):
	current_health = min(current_health + amount, entity.max_health)
	emit_signal("_on_regen")
	update_health_bar()

func take_damage(damage: float):
	if is_invincible or is_dead: 
		return

	current_health -= damage
	if current_health <= 0:
		is_dead = true
		emit_signal("_on_death")
	else:
		emit_signal("_on_take_damage")
	update_health_bar()

func update_health_bar():
	ArrayUtils.foreach(health_bars, "set_health_bar", [current_health / entity.max_health])
