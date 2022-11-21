extends NavState
class_name GruntNavState

func get_state_name():
    return "GruntNavState"

func enter():
    print("Entered GruntNavState")
    find_path(GameManager.voxel_manager.voxel_to_global(Vector3(0, 0, 0)))
    start_timer(3, ["GruntIdleState", "GruntNavState"])

func exit():
    print("Exited GruntNavState")

func physics_update(delta: float):
    if nav_path != null:
        follow_path(delta)

