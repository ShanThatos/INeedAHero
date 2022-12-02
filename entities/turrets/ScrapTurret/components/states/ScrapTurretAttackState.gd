extends GenericState
class_name ScrapTurretAttackState

var cooldown = 0.0

var projectile = preload("res://entities/turrets/TurretProjectile/TurretProjectile.tscn")

func get_state_name(): return "ScrapTurretAttackState"

func enter():
	entity.look_at(entity.target_body.global_translation, Vector3.UP)
	var bullet: KinematicBody = projectile.instance()
	bullet.target_body = entity.target_body
	GameManager.level_manager.add_child(bullet)
	bullet.global_translation = entity.projectile_spawn_point.global_translation
	machine.switch_state("ScrapTurretTargetState")

func exit():
	cooldown = entity.attack_cooldown

func detached_physics_update(delta: float):
	if cooldown >= 0:
		cooldown -= delta

func should_enter():
	if not machine.current_state_matches(["ScrapTurretTargetState"]):
		return false
	return entity.target_body != null and cooldown <= 0
