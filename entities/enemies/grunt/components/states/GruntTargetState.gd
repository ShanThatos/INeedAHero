extends GenericState
class_name GruntTargetState

var timer: SceneTreeTimer

func get_state_name():
	return "GruntTargetState"

func enter():
	print("Entering GruntTargetState")
	timer = entity.get_tree().create_timer(entity.attack_cooldown)
	# print(GameManager.level_manager.base_entity.get_center())

func exit():
	print("Exiting GruntTargetState")

func is_near_base():
	var target_zone_area = entity.target_zone as Area
	var bodies = target_zone_area.get_overlapping_bodies()
	for body in bodies:
		if !("voxel_entity" in body.get_meta_list()):
			continue
		var voxel = body.get_meta("voxel_entity")
		if voxel == GameManager.level_manager.base_entity:
			return true
	return false

func physics_update(_delta: float):
	if !is_near_base():
		machine.switch_state("GruntIdleState")
		return
	if timer.time_left <= 0:
		machine.switch_state("GruntAttackState")
		return
	
	var base_global_pos = GameManager.voxel_manager.voxel_to_global(GameManager.level_manager.base_entity.get_center())
	var direction = MathUtils.get_xz_subvector(base_global_pos - entity.global_translation).normalized()
	var level_scale = GameManager.level_manager.get_level_scale()
	var velocity = direction * entity.movement_speed * level_scale
	velocity.y -= entity.gravity * level_scale
	var body = entity as KinematicBody
	body.move_and_slide(velocity, Vector3.UP)
	body.look_at(entity.global_translation + direction, Vector3.UP)

func should_enter():
	if !machine.current_state_matches(["GruntIdleState", "GruntNavState"]):
		return false
	return is_near_base()
