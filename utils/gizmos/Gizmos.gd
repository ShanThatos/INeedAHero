extends Node

const LineGizmo = preload("res://utils/gizmos/LineGizmo.tscn")

const RED = Color(1, 0, 0, .5)
const YELLOW = Color(1, 1, 0, .5)
const WHITE = Color(1, 1, 1, .5)

var color = WHITE
var lifetime = 5
var stroke = 1

var active_gizmos = []

func create_line(start: Vector3, end: Vector3, add_to_scene := true):
	var line: Spatial = LineGizmo.instance()
	line.get_node("MeshInstance").get_active_material(0).albedo_color = color
	if start.x == end.x and start.z == end.z:
		line.translation = start
		line.scale_object_local(Vector3(stroke, stroke, start.distance_to(end)))
		if start.y < end.y:
			line.rotation_degrees.x = 90
		else:
			line.rotation_degrees.x = -90
	else:
		line.look_at_from_position(start, end, Vector3.UP)
		line.scale_object_local(Vector3(stroke, stroke, start.distance_to(end)))
	if add_to_scene:
		add_gizmo_to_scene(line)
	return line

func create_path(path: Array, add_to_scene := true):
	var path_node = Spatial.new()
	for i in range(path.size() - 1):
		var line = create_line(path[i], path[i + 1], false)
		path_node.add_child(line)
		line.look_at_from_position(path[i], path[i + 1], Vector3.UP)
	if add_to_scene:
		add_gizmo_to_scene(path_node)
	return path_node

func add_gizmo_to_scene(gizmo):
	active_gizmos.append([gizmo, lifetime])
	add_child(gizmo)

func clear_gizmos():
	for gizmo in active_gizmos:
		gizmo[0].queue_free()
	active_gizmos.clear()

func _physics_process(delta):
	for i in range(active_gizmos.size() - 1, -1, -1):
		var gizmo = active_gizmos[i][0]
		var time_left = active_gizmos[i][1]
		time_left -= delta
		if time_left <= 0:
			gizmo.queue_free()
			active_gizmos.remove(i)
		else:
			active_gizmos[i][1] = time_left
