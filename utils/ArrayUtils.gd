class_name ArrayUtils

static func _special_call_with_args(el, function, arguments: Array, optional := false):
	if function is String:
		var has_method = el.has_method(function)
		assert(has_method or optional, "Method not found: " + function)
		if has_method:
			return el.callv(function, arguments)
		return null
	elif function is FuncRef:
		var args_with_el = [el]
		args_with_el.append_array(arguments)
		return function.call_funcv(args_with_el)
	else:
		assert(false, "Invalid function type")
		return null

# given a function: String, call that function for each element
# fiven a function: FuncRef, call the function and pass each element as an argument
static func foreach(arr: Array, function, arguments: Array = [], optional := false):
	var results = []
	for el in arr:
		results.append(_special_call_with_args(el, function, arguments, optional))
	return results

static func all(arr: Array, function, arguments: Array = []) -> bool:
	for el in arr:
		if not _special_call_with_args(el, function, arguments):
			return false
	return true

static func any(arr: Array, function, arguments: Array = []) -> bool:
	for el in arr:
		if _special_call_with_args(el, function, arguments):
			return true
	return false

# static func flatten(arr1: Array) -> Array:
# 	var results = []
# 	for el in arr1:
# 		if el is Array:
# 			results.append_array(flatten(el))
# 		else:
# 			results.append(el)
# 	return results
