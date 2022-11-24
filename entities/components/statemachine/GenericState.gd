extends Reference
class_name GenericState


var machine
var entity

# func get_state_name():
#     return ""

# func start():
#     pass

# func enter():
#     pass

# func exit():
#     pass

# func physics_update(_delta: float): 
#     pass

# func should_enter():
#     return false

func start_timer(time: float, future_states: Array):
    assert(future_states.size() > 0, "A timed state must have at least one future state")
    yield(entity.get_tree().create_timer(time), "timeout")
    machine.switch_state(future_states)

# leave out future_states to avoid switching to another state upon the animation ending
func start_animation(animation_name: String, future_states := []):
    entity.animator.play(animation_name)
    if future_states.size() > 0:
        yield(entity.animator, "animation_finished")
        machine.switch_state(future_states)
