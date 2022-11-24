extends GenericState
class_name GruntAttackState

func get_state_name():
    return "GruntAttackState"

func enter():
    print("Entered GruntAttackState")
    start_animation("GruntAttack", ["GruntTargetState"])
