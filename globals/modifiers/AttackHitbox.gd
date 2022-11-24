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
    if !("voxel_entity" in body.get_meta_list()):
        return
    var voxel_entity = body.get_meta("voxel_entity")
    if !(voxel_entity is Entity):
        return
    if !voxel_entity.has_component("HealthComponent"):
        return
    if voxel_entity in attacked:
        return
    
    attacked.append(voxel_entity)
    voxel_entity.get_component("HealthComponent").take_damage(damage)
