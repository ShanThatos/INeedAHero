extends Entity
class_name ScrapTurret

export(float)   var max_health := 30.0
export(float)   var target_view_distance := 10.0
export(float)   var attack_cooldown := 1.0

onready var turret_head: Spatial = $Head
onready var target_check_raycast: RayCast = $Head/TargetCheckRaycast
onready var target_check_area: Area = $Head/TargetCheckArea
onready var projectile_spawn_point: Spatial = $Head/ProjectileSpawnPoint

var target_body: PhysicsBody = null

func start():
    var level_scale = GameManager.level_manager.get_level_scale()
    target_check_area.scale = Vector3.ONE * target_view_distance * level_scale

func register_components():
    var components := FileUtils.load_scripts(["HealthComponent"], "res://entities/components/")
    components.append_array(FileUtils.load_scripts(["ScrapTurretStateMachine"], FileUtils.get_script_base_dir(self)))
    return components

func can_see_target(body: PhysicsBody):
    var level_scale = GameManager.level_manager.get_level_scale()
    var body_pos = body.global_translation + Vector3.UP * level_scale * .7

    if body_pos.distance_to(turret_head.global_translation) > target_view_distance * level_scale:
        return false

    target_check_raycast.cast_to = turret_head.to_local(body_pos)
    target_check_raycast.force_raycast_update()
    return target_check_raycast.get_collider() == body
