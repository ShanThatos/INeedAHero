class_name ArrayUtils

# given a function: String, call that function for each element
# fiven a function: FuncRef, call the function and pass each element as an argument
static func foreach(arr: Array, function, arguments: Array = []):
	var results = []
	for el in arr:
		if function is String:
			assert(el.has_method(function), "Object does not have method " + function)
			results.append(el.callv(function, arguments))
		elif function is FuncRef:
			var args_with_el = [el]
			args_with_el.append_array(arguments)
			results.append(function.call_funcv(args_with_el))
	return results

static func flatten(arr1: Array):
	var results = []
	for el in arr1:
		if el is Array:
			results.append_array(flatten(el))
		else:
			results.append(el)
	return results

static func all(arr: Array, function, arguments: Array = []):
	var results = foreach(arr, function, arguments)
	for el in results:
		if not el:
			return false
	return true
