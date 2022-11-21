extends Spatial
class_name NavManager

func _ready():
	name = "NavManager"
	GameManager.nav_manager = self

func a_star_heuristic(from: Vector3, to: Vector3):
	return from.distance_to(to)

class AStarNode extends Reference:
	var path: Array
	var pos: Vector3
	var cost: float
	var heuristic: float

	func _init(_path: Array, _pos: Vector3, _cost: float, _heuristic: float):
		path = _path
		pos = _pos
		cost = _cost
		heuristic = _heuristic

	func get_score() -> float:
		return cost + heuristic
	
	func compare(other) -> float:
		return get_score() - other.get_score()


func has_ground_at(voxel_pos: Vector3) -> bool:
	voxel_pos = voxel_pos + Vector3.DOWN
	if voxel_pos.y <= 0:
		return true
	if GameManager.voxel_manager.get_voxel_at(voxel_pos) != null:
		return true
	return false

func can_fit_at(voxel_pos: Vector3, height: float) -> bool:
	if !has_ground_at(voxel_pos):
		return false
	for dy in range(ceil(height)):
		var test_pos = voxel_pos + Vector3(0, dy, 0)
		var voxel = GameManager.voxel_manager.get_voxel_at(test_pos)
		if voxel != null:
			return false
	return true

const XZ_MOVEMENT = [[1, 0], [0, 1], [-1, 0], [0, -1]]
const XZ_DIAG_MOVEMENT = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
func get_neighbor_positions(voxel_pos: Vector3, height: float) -> Array:
	var neighbors = []
	for dxz in XZ_MOVEMENT:
		var neighbor_pos = voxel_pos + Vector3(dxz[0], 0, dxz[1])
		if can_fit_at(neighbor_pos, height):
			neighbors.append(neighbor_pos)
	for dxz in XZ_DIAG_MOVEMENT:
		var test_positions = [
			voxel_pos + Vector3(dxz[0], 0, dxz[1]),
			voxel_pos + Vector3(dxz[0], 0, 0),
			voxel_pos + Vector3(0, 0, dxz[1])
		]
		if ArrayUtils.all(test_positions, funcref(self, "can_fit_at"), [height]):
			neighbors.append(test_positions[0])

	return neighbors

func find_path_voxel(voxel_start: Vector3, voxel_end: Vector3, height := 1.0, max_path := 5):
	var voxel_end_floor = voxel_end.floor()
	var heap = MinHeap.new()
	var start_node = AStarNode.new([voxel_start], voxel_start, 0, a_star_heuristic(voxel_start, voxel_end))
	heap.push(start_node)

	var visited = []
	while heap.size():
		var current_node = heap.pop()

		var voxel_pos = current_node.pos.floor()
		if voxel_pos in visited:
			continue
		visited.append(voxel_pos)

		if voxel_pos.is_equal_approx(voxel_end_floor):
			return current_node.path.duplicate()
		
		if current_node.path.size() >= max_path:
			return current_node.path.duplicate()

		var neighbors = get_neighbor_positions(current_node.pos, height)
		for neighbor in neighbors:
			var new_path = current_node.path.duplicate()
			new_path.append(neighbor)
			var new_cost = current_node.cost + current_node.pos.distance_to(neighbor)
			var new_node = AStarNode.new(new_path, neighbor, new_cost, a_star_heuristic(neighbor, voxel_end))
			heap.push(new_node)
	
	return null

func find_path_global(start: Vector3, end: Vector3, height := 1.0):
	var voxel_start = GameManager.voxel_manager.global_to_voxel(start, false)
	var voxel_end = GameManager.voxel_manager.global_to_voxel(end, false)
	
	var path = find_path_voxel(voxel_start, voxel_end, height)
	if path == null:
		return null
	path = ArrayUtils.foreach(path, funcref(GameManager.voxel_manager, "voxel_to_global"))
	return path

