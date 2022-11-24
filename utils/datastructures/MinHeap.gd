extends Reference
class_name MinHeap


var arr = []

func swap(i: int, j: int) -> void:
	var temp = arr[i]
	arr[i] = arr[j]
	arr[j] = temp

func push(item):
	arr.append(item)
	
	var current = arr.size() - 1
	var parent = (current - 1) / 2
	while arr[current].compare(arr[parent]) < 0:
		swap(current, parent)
		current = parent
		parent = (current - 1) / 2

func pop():
	var ret = arr[0]
	var last = arr.pop_back()
	if arr.size() > 0:
		arr[0] = last

	var current = 0
	while true:
		var left = 2 * current + 1
		var right = 2 * current + 2
		var smallest = current

		if left < arr.size() and arr[left].compare(arr[smallest]) < 0:
			smallest = left
		if right < arr.size() and arr[right].compare(arr[smallest]) < 0:
			smallest = right

		if smallest == current:
			break

		swap(current, smallest)
		current = smallest

	return ret

func size():
	return arr.size()
