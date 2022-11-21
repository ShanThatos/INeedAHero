extends Component
class_name StateMachine


var states: Array = []
var current_state: int = -1


func get_component_name(): return "StateMachine"

# override and return a list of PackedScene objects (preload each state)
func preload_states(): 
	return []

func start(entity):
	
	states = preload_states()
	states = ArrayUtils.foreach(states, "new")
	ArrayUtils.foreach(states, "set_machine", [self])
	ArrayUtils.foreach(states, "set_entity", [entity])

	var state_names = ArrayUtils.foreach(states, "get_state_name")
	for state_name in state_names:
		assert(state_name != "", "State name cannot be empty")
		assert(state_names.count(state_name) == 1, "State name must be unique")
	
	ArrayUtils.foreach(states, "start")
	
	switch_state(states[0])

func physics_update(_entity, _delta: float):
	if current_state >= 0 and current_state < states.size():
		states[current_state].physics_update(_delta)
	
	for state in states:
		if state.should_enter():
			switch_state(state)


# func frame_update(_entity, _delta: float):
# 	pass

# func input_update(_entity, _event: InputEvent):
# 	pass



func switch_state(next_state):
	var next_state_name: String = ""
	if next_state is String:
		next_state_name = next_state
	elif next_state is Array:
		next_state_name = next_state[randi() % next_state.size()]
	else:
		next_state_name = next_state.get_state_name()
	assert(next_state_name != "", "Invalid state/name " + str(next_state))
	
	var next_state_index := -1
	for i in range(states.size()):
		if states[i].get_state_name() == next_state_name:
			next_state_index = i
			break
	
	assert(next_state_index != -1, "Cannot find state " + next_state_name)

	if current_state >= 0 and current_state < states.size():
		states[current_state].exit()
	current_state = next_state_index
	if current_state >= 0 and current_state < states.size():
		states[current_state].enter()
