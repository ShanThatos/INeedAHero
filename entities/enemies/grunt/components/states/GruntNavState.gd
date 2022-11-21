extends NavState
class_name GruntNavState

var timer: SceneTreeTimer

func get_state_name():
    return "GruntNavState"

func enter():
    print("Entered GruntNavState")
    find_path(GameManager.voxel_manager.voxel_to_global(Vector3(0, 0, 0)))
    timer = entity.get_tree().create_timer(5)

func exit():
    print("Exited GruntNavState")

func physics_update(delta: float):
    follow_path(delta)
    if timer.time_left <= 0 or has_finished_path():
        machine.switch_state("GruntNavState")

