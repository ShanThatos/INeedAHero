extends Spatial
class_name NavManager

func _ready():
	name = "NavManager"
	GameManager.nav_manager = self

class AStarNode extends Reference:
	var prev := -1
	var id: int
	var pos: Vector3
	var cost: float
	var heuristic: float
	var depth: int

	func _init(_id: int, _pos: Vector3, _cost: float, _heuristic: float, _depth: int):
		id = _id
		pos = _pos
		cost = _cost
		heuristic = _heuristic
		depth = _depth
	
	func compare(other) -> float:
		return (cost + heuristic) - (other.cost + other.heuristic)

class AStarSolver extends Reference:
	
	const XZ_MOVEMENT = [[1, 0], [0, 1], [-1, 0], [0, -1]]
	const XZ_DIAG_MOVEMENT = [[1, 1], [-1, 1], [-1, -1], [1, -1]]

	var max_path := 5
	var height := 1.0
	var step_size := 1.0
	var voxel_start: Vector3
	var voxel_ends: Array
	
	func _init():
		pass

	func heuristic(voxel_pos: Vector3):
		var min_dist = 9999999.0
		for voxel_end in voxel_ends:
			var dist = voxel_pos.distance_to(voxel_end)
			if dist < min_dist:
				min_dist = dist
		return min_dist

	func has_ground_at(voxel_pos: Vector3) -> bool:
		voxel_pos = voxel_pos + Vector3.DOWN
		if voxel_pos.y <= 0:
			return true
		if GameManager.voxel_manager.get_voxel_at(voxel_pos) != null:
			return true
		return false
	
	func can_fit_at(voxel_pos: Vector3) -> bool:
		if !has_ground_at(voxel_pos):
			return false
		for dy in range(ceil(height)):
			var test_pos = voxel_pos + Vector3(0, dy, 0)
			var voxel = GameManager.voxel_manager.get_voxel_at(test_pos)
			if voxel != null:
				return false
		return true

	func get_neighbors(astar_node: AStarNode) -> Array:
		var neighbors = []
		var voxel_pos = astar_node.pos
		for dxz in XZ_MOVEMENT:
			var neighbor_pos = voxel_pos + step_size * Vector3(dxz[0], 0, dxz[1])
			if can_fit_at(neighbor_pos):
				neighbors.append(neighbor_pos)
		for dxz in XZ_DIAG_MOVEMENT:
			var test_positions = [
				voxel_pos + step_size * Vector3(dxz[0], 0, dxz[1]),
				voxel_pos + step_size * Vector3(dxz[0], 0, 0),
				voxel_pos + step_size * Vector3(0, 0, dxz[1])
			]  
			if ArrayUtils.all(test_positions, funcref(self, "can_fit_at")):
				neighbors.append(test_positions[0])
		return neighbors
	
	func get_path_to(all_nodes: Array, current_node: AStarNode):
		var current = current_node.id
		var path = []
		while current != -1:
			path.push_front(all_nodes[current].pos)
			current = all_nodes[current].prev
		return path

	func find_path_voxel(_voxel_start: Vector3, _voxel_ends: Array):
		voxel_start = _voxel_start
		voxel_ends = _voxel_ends

		var heap = MinHeap.new()
		var all_nodes = []
		var start_node = AStarNode.new(all_nodes.size(), voxel_start, 0, heuristic(voxel_start), 1)
		heap.push(start_node)
		all_nodes.append(start_node)

		var visited = []
		while heap.size():
			var current_node: AStarNode = heap.pop()

			var voxel_pos = current_node.pos
			var found_match = false
			for node_pos in visited:
				if voxel_pos.is_equal_approx(node_pos):
					found_match = true
					break
			if found_match:
				continue
			visited.append(voxel_pos)

			if heuristic(voxel_pos) < step_size or current_node.depth >= max_path:
				return get_path_to(all_nodes, current_node)

			var neighbors = get_neighbors(current_node)
			for neighbor in neighbors:
				var new_cost = current_node.cost + current_node.pos.distance_to(neighbor)
				var new_node = AStarNode.new(all_nodes.size(), neighbor, new_cost, heuristic(neighbor), current_node.depth + 1)
				heap.push(new_node)
				all_nodes.append(new_node)
				new_node.prev = current_node.id
		
		var best_node = all_nodes[0]
		for node in all_nodes:
			if node.heuristic < best_node.heuristic:
				best_node = node
			elif node.heuristic == best_node.heuristic and node.cost < best_node.cost:
				best_node = node

		return get_path_to(all_nodes, best_node)

	func find_path_global(start: Vector3, ends: Array):
		var vm = GameManager.voxel_manager
		var _voxel_ends = ArrayUtils.foreach(ends, funcref(vm, "global_to_voxel"), [false])
		var path = find_path_voxel(vm.global_to_voxel(start, false), _voxel_ends)
		if path == null:
			return null
		return ArrayUtils.foreach(path, funcref(vm, "voxel_to_global"))

