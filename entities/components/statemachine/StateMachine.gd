extends Component
class_name StateMachine


var states: Array = []
var current_state: int = -1


func get_component_name(): return "StateMachine"

# override and return a list of PackedScene objects (preload each state)
func preload_states(): 
	return []

func start():
	
	states = preload_states()
	assert(states.size() > 0, "No states to load")
	states = ArrayUtils.foreach(states, "new")
	ArrayUtils.foreach(states, "set", ["machine", self])
	ArrayUtils.foreach(states, "set", ["entity", entity])

	var state_names = ArrayUtils.foreach(states, "get_state_name")
	for state_name in state_names:
		assert(state_name != "", "State name cannot be empty")
		assert(state_names.count(state_name) == 1, "State name must be unique")
	
	ArrayUtils.foreach(states, "start", [], true)
	
	switch_state(states[0])

func check_should_enter():
	for state in states:
		if state.has_method("should_enter") and state.should_enter():
			switch_state(state)

func call_for_current_state(method_name, args := []):
	if current_state >= 0 and current_state < states.size():
		if states[current_state].has_method(method_name):
			states[current_state].callv(method_name, args)

func physics_update(delta: float):
	call_for_current_state("physics_update", [delta])
	check_should_enter()

func frame_update(_delta: float):
	call_for_current_state("frame_update")

func input_update(event: InputEvent):
	call_for_current_state("input_update", [event])

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

	call_for_current_state("exit")
	current_state = next_state_index
	call_for_current_state("enter")

func current_state_matches(state_names: Array):
	if current_state >= 0 and current_state < states.size():
		return states[current_state].get_state_name() in state_names
	return false
