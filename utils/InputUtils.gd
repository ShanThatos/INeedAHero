class_name InputUtils


static func get_input_movement_axis() -> Vector2:
    var x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    var y = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
    return Vector2(x, y).normalized()