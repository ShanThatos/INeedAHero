extends Component
class_name FirstPersonController

var first_person_camera: Camera
var forward_ray_cast: RayCast

var default_near_plane: float
var default_forward_raycast: Vector3


func get_component_name(): return "FirstPersonController"

func start():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	first_person_camera = entity.get_node("FirstPersonCamera")
	forward_ray_cast = first_person_camera.get_node("ForwardRayCast")
	first_person_camera.make_current()
	default_near_plane = first_person_camera.near
	default_forward_raycast = forward_ray_cast.cast_to

func update_level_scaled_values():
	var level_scale = GameManager.level_manager.get_level_scale()
	first_person_camera.near = default_near_plane * level_scale
	forward_ray_cast.cast_to = default_forward_raycast * level_scale

func get_accel_vector() -> Vector3:
	var basis = entity.transform.basis
	
	var forward = MathUtils.get_xz_subvector(-basis.z).normalized()
	var right = MathUtils.get_xz_subvector(basis.x).normalized()

	var input_axis = InputUtils.get_input_movement_axis()
	var accel_vector = forward * input_axis.y + right * input_axis.x
	return accel_vector

func physics_update(delta: float):
	update_level_scaled_values()
	var scale_multiplier = GameManager.level_manager.get_level_scale()
	var delta_scale_multiplier = delta * scale_multiplier

	var player_entity := entity as PlayerEntity
	var player_body := entity as KinematicBody
	
	var velocity = player_entity.velocity
	var snap_vector = Vector3.DOWN * scale_multiplier

	var accel := get_accel_vector()
	velocity += accel * player_entity.movement_acceleration * delta_scale_multiplier
	var apply_friction = accel.dot(velocity) <= 0

	var velocity_xz := MathUtils.get_xz_subvector(velocity)
	if apply_friction:
		velocity_xz *= pow(player_entity.deceleration_rate / 100, delta)
	
	if velocity_xz.length() > player_entity.max_speed * scale_multiplier:
		velocity_xz = velocity_xz.normalized() * player_entity.max_speed * scale_multiplier

	velocity = Vector3(velocity_xz.x, velocity.y - player_entity.gravity_acceleration * delta_scale_multiplier, velocity_xz.z)
	velocity = player_body.move_and_slide_with_snap(velocity, snap_vector, Vector3.UP, true, 4, deg2rad(50))
	player_entity.velocity = velocity

func frame_update(_delta: float):
	var player_entity = entity as PlayerEntity
	var player_body = entity as KinematicBody
	
	var mouse_delta = player_entity.mouse_delta
	player_entity.mouse_delta = Vector2.ZERO

	player_body.rotate_y(deg2rad(-mouse_delta.x * player_entity.horiz_rotation_speed / 100))
	first_person_camera.rotate_x(deg2rad(-mouse_delta.y * player_entity.vert_rotation_speed / 100))
	first_person_camera.rotation_degrees.x = clamp(first_person_camera.rotation_degrees.x, player_entity.min_x_rotation, player_entity.max_x_rotation)

func input_update(event: InputEvent):
	if event is InputEventMouseMotion:
		entity.mouse_delta += event.relative
