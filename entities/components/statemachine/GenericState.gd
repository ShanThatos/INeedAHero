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