extends KinematicBody
class_name TurretProjectile

export(float)   var speed := 0.0

var target_body: PhysicsBody
var collided = false

func _physics_process(delta: float):
    if collided:
        return

    var level_scale = GameManager.level_manager.get_level_scale()
    var body_pos = target_body.global_translation + Vector3.UP * level_scale * .7
    var direction = (body_pos - global_translation).normalized()
    var velocity = direction * speed * level_scale * delta
    rotate_z(TAU * delta)
    look_at(body_pos, global_transform.basis.y)
    
    if move_and_collide(velocity):
        collided = true
        yield(get_tree().create_timer(0.1), "timeout") # give attackhitbox enough time to realize a hit
        queue_free()