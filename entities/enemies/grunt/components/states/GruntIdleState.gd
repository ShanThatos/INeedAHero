extends TimedState
class_name GruntIdleState

func get_state_name():
    return "GruntIdleState"

func get_time():
    return 5

func get_future_states():
    return ["GruntIdleState"]

func enter():
    start_timer()
    print("Entered GruntIdleState")

func exit():
    print("Exited GruntIdleState")