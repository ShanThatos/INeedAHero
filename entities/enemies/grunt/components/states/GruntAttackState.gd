extends GenericState
class_name GruntAttackState

func get_state_name():
    return "GruntAttackState"

func enter():
    start_animation("GruntAttack", ["GruntIdleState", "GruntNavState", "GruntTargetState"])
