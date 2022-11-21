extends GenericState
class_name GruntIdleState

func get_state_name():
    return "GruntIdleState"

func enter():
    start_timer(1, ["GruntNavState"])
    print("Entered GruntIdleState")

func exit():
    print("Exited GruntIdleState")