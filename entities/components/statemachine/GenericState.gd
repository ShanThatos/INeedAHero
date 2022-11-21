extends Reference
class_name GenericState


var machine
var entity

func get_state_name():
    return ""

func start():
    pass

func enter():
    pass

func exit():
    pass

func physics_update(_delta: float): 
    pass

func should_enter():
    return false

func set_machine(_machine):
    machine = _machine

func set_entity(_entity):
    entity = _entity

func start_timer(time: float, future_states: Array):
    assert(future_states.size() > 0, "TimedState must have at least one future state")
    yield(entity.get_tree().create_timer(time), "timeout")
    machine.switch_state(future_states[randi() % future_states.size()])
