extends Component
class_name HealthComponent

var current_health: float
var is_invincible := false
var is_dead := false

signal _on_regen
signal _on_take_damage
signal _on_death

func get_component_name(): return "HealthComponent"

func start():
	current_health = entity.max_health

func regen_health(amount: float):
	current_health = min(current_health + amount, entity.max_health)
	emit_signal("_on_regen")

func take_damage(damage: float):
	print(entity, " took ", damage, " damage")

	if is_invincible or is_dead: 
		return

	current_health -= damage
	if current_health <= 0:
		is_dead = true
		emit_signal("_on_death")
	else:
		emit_signal("_on_take_damage")
