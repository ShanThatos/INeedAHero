extends GenericState
class_name GruntIdleState

func get_state_name():
    return "GruntIdleState"

func enter():
    start_timer(5, ["GruntNavState"])
