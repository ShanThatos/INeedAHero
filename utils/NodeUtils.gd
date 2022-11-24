class_name NodeUtils

# returns an array of all children and subchildren of the given node
static func get_all_children(node, arr := []):
    arr.append(node)
    for child in node.get_children():
        arr = get_all_children(child, arr)
    return arr

# returns an array of all children and subchildren of the given node with the given type
static func get_all_children_with_type(node, type):
    var arr = []
    for child in get_all_children(node):
        if child is type:
            arr.append(child)
    return arr
