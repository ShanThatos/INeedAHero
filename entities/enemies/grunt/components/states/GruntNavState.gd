extends NavState
class_name GruntNavState

var timer: SceneTreeTimer

func get_state_name():
    return "GruntNavState"

func enter():
    find_path_voxel(GameManager.level_manager.base_entity.get_bottom_corners())
    timer = entity.get_tree().create_timer(5)

func physics_update(delta: float):
    follow_path(delta)
    if is_stuck():
        machine.switch_state("GruntAttackState")
    if timer.time_left <= 0 or has_finished_path():
        machine.switch_state(["GruntAttackState", "GruntNavState"])


