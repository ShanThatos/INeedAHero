extends GenericState
class_name GruntIdleState

func get_state_name():
    return "GruntIdleState"

func enter():
    start_timer(rand_range(4, 6), ["GruntNavState"])
