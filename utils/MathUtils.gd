class_name MathUtils

static func get_xz_subvector(vector: Vector3) -> Vector3:
    return Vector3(vector.x, 0, vector.z)

static func get_closest_point_on_segment(point: Vector3, segment_start: Vector3, segment_end: Vector3) -> Vector3:
    var segment = segment_end - segment_start
    var segment_length = segment.length()
    var segment_direction = segment.normalized()
    var point_to_segment_start = point - segment_start
    var projection = point_to_segment_start.dot(segment_direction)
    projection = clamp(projection, 0, segment_length)
    return segment_start + segment_direction * projection

static func get_closest_point_on_path(point: Vector3, path: Array):
    var closest_point = path[0]
    var closest_distance = point.distance_to(path[0])
    var closest_index = 0
    for i in range(path.size() - 1):
        var point_on_path = get_closest_point_on_segment(point, path[i], path[i + 1])
        var distance = point.distance_to(point_on_path)
        if distance < closest_distance:
            closest_distance = distance
            closest_point = point_on_path
            closest_index = i
    return [closest_point, closest_index]
