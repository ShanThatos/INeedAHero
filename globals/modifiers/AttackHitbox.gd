extends Area
class_name AttackHitbox

export(Vector3)     var knockback: Vector3 = Vector3.ZERO
export(float)       var damage: float = 0.0

var attacked = []

func _ready():
    var _ignore = connect("body_entered", self, "on_body_entered")

func reset_attack():
    attacked = []

func on_body_entered(body: Node):
    if !("entity" in body.get_meta_list()):
        return
    var entity = body.get_meta("entity")
    if !(entity is Entity):
        return
    if !entity.has_component("HealthComponent"):
        return
    if entity in attacked:
        return
    
    attacked.append(entity)
    entity.get_component("HealthComponent").take_damage(damage)
