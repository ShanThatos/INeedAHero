extends KinematicBody
class_name TurretProjectile

export(float)   var speed := 0.0

var target_body: PhysicsBody
var finished = false
var lifetime = 20.0

func _physics_process(delta: float):
	if finished:
		return
	
	lifetime -= delta
	if lifetime <= 0:
		finished = true
		if !is_queued_for_deletion():
			queue_free()
		return

	var level_scale = GameManager.level_manager.get_level_scale()

	var direction = -global_transform.basis.z.normalized()
	if is_instance_valid(target_body):
		var body_pos = target_body.global_translation + Vector3.UP * level_scale * .7
		direction = (body_pos - global_translation).normalized()
		look_at(body_pos, global_transform.basis.y)
	
	var velocity = direction * speed * level_scale * delta
	if move_and_collide(velocity):
		finished = true
		yield(get_tree().create_timer(0.1), "timeout") # give attackhitbox enough time to realize a hit
		if !is_queued_for_deletion():
			queue_free()
