extends KinematicBody
class_name TurretProjectile

export(float)   var speed := 1000.0
export(float)   var damage := 10.0

var target_body: PhysicsBody

func _physics_process(delta: float):
    var level_scale = GameManager.level_manager.get_level_scale()
    var body_pos = target_body.global_translation + Vector3.UP * level_scale * .7
    var direction = (body_pos - global_translation).normalized()
    var velocity = direction * speed * level_scale * delta
    rotate_z(TAU * delta)
    look_at(body_pos, global_transform.basis.y)
    
    var collision = move_and_collide(velocity)

    if collision:
        var valid_collision = true
        valid_collision = valid_collision and collision.collider == target_body
        valid_collision = valid_collision and "voxel_entity" in target_body.get_meta_list()
        valid_collision = valid_collision and target_body.get_meta("voxel_entity") is Entity
        valid_collision = valid_collision and target_body.get_meta("voxel_entity").has_component("HealthComponent")
        if valid_collision:
            var health_component = target_body.get_meta("voxel_entity").get_component("HealthComponent")
            health_component.take_damage(damage)
        queue_free()

