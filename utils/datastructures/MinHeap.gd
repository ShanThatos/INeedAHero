extends Reference
class_name MinHeap


var arr = []

func push(item):
    arr.append(item)
    arr.sort_custom(self, "compare")

func pop():
    return arr.pop_front()

func compare(a, b):
    return a.compare(b) < 0

func size():
    return arr.size()
