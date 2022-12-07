extends GenericState
class_name ScrapTurretTargetState

func get_state_name(): return "ScrapTurretTargetState"

func physics_update(_delta: float):
    var level_scale = GameManager.level_manager.get_level_scale()
    var bodies = entity.target_check_area.get_overlapping_bodies()
    var target_body = null
    for body in bodies:
        if not entity.can_see_target(body):
            continue
        if target_body == null or body.global_translation.distance_to(entity.global_translation) < target_body.global_translation.distance_to(entity.global_translation):
            target_body = body
    entity.target_body = target_body
    
    if target_body:
        var target_pos = target_body.global_translation + Vector3.UP * level_scale * .7
        entity.turret_head.look_at(target_pos, Vector3.UP)
