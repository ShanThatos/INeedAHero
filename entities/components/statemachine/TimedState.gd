extends GenericState
class_name TimedState

func get_time():
    return 5

func get_future_states():
    return []

func start_timer():
    yield(entity.get_tree().create_timer(get_time()), "timeout")
    var future_states = get_future_states()
    assert(future_states.size() > 0, "TimedState must have at least one future state")
    machine.switch_state(future_states[randi() % future_states.size()])

