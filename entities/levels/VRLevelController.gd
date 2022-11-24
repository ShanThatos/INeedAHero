extends Node
class_name VRLevelController

const vr_button_scene = preload("res://entities/ui/vr/VRButton.tscn")
const level_manager_scene = preload("res://globals/managers/LevelManager.tscn")
const ground_scene = preload("res://entities/voxels/ground/Ground.tscn")
const vr_player_scene = preload("res://entities/player/VRPlayer.tscn")

onready var xr_origin: ARVROrigin = $ARVROrigin
onready var left_hand: Spatial = $ARVROrigin/LeftHand
onready var right_hand: Spatial = $ARVROrigin/RightHand
onready var main_label: Label3D = $MainLabel

var main_vr_button: Spatial = null

func _ready():
	var XR = ARVRServer.find_interface("OpenXR")
	if XR and XR.initialize():
		var vp = get_viewport()
		vp.arvr = true
		OS.vsync_enabled = false
		Engine.target_fps = 90
		var config_gdns = load("res://addons/godot-openxr/config/OpenXRConfig.gdns")
		var xr_config = config_gdns.new()
		vp.transparent_bg = true
		xr_config.start_passthrough()

		start_level_initialization()

func start_level_initialization():
	yield(get_tree().create_timer(1.0), "timeout")
	ARVRServer.center_on_hmd(ARVRServer.RESET_BUT_KEEP_TILT, true)

	main_vr_button = vr_button_scene.instance()
	add_child(main_vr_button)
	main_vr_button.visible = false

	yield(get_tree().create_timer(2.0), "timeout")

	main_label.text = "Place left hand at top\nleft corner of the table"
	main_vr_button.visible = true

	yield(main_vr_button, "_on_vrbutton_press")
	var top_left_pos := left_hand.global_translation
	main_label.text = "Good!"
	main_vr_button.visible = false

	yield(get_tree().create_timer(2.0), "timeout")
	main_label.text = "Place left hand at top\nright corner of the table"
	main_vr_button.visible = true

	yield(main_vr_button, "_on_vrbutton_press")
	var top_right_pos := left_hand.global_translation
	main_label.text = "Good!"
	main_vr_button.visible = false

	yield(get_tree().create_timer(2.0), "timeout")
	main_label.text = "Place left hand at bottom\nleft corner of the table"
	main_vr_button.visible = true

	yield(main_vr_button, "_on_vrbutton_press")
	var bottom_left_pos := left_hand.global_translation
	main_label.text = "Good!"
	main_vr_button.visible = false

	var average_y = (top_left_pos.y + top_right_pos.y + bottom_left_pos.y) / 3.0
	top_left_pos.y = average_y
	top_right_pos.y = average_y
	bottom_left_pos.y = average_y
	average_y -= .015

	var tl_to_tr = top_right_pos - top_left_pos
	# making the table rectanglish
	var tl_to_bl = bottom_left_pos - top_left_pos
	tl_to_bl = tl_to_bl - tl_to_bl.project(tl_to_tr)
	bottom_left_pos = top_left_pos + tl_to_bl

	var left_edge_length = tl_to_bl.length()
	var top_edge_length = tl_to_tr.length()

	var level_scale = max(.03, min(left_edge_length, top_edge_length) / 40.0)
	
	var level = level_manager_scene.instance()
	level.scale = Vector3.ONE * level_scale

	var ground = ground_scene.instance()
	ground.scale = Vector3(top_edge_length / level_scale, 1, left_edge_length / level_scale)

	level.translation = (top_right_pos + bottom_left_pos) / 2.0

	level.add_child(ground)
	add_child(level)

	level.look_at((top_left_pos + top_right_pos) / 2.0, Vector3.UP)
	level.add_child(vr_player_scene.instance())

func _process(_delta: float):
	if main_vr_button != null:
		main_vr_button.global_translation = left_hand.global_translation + Vector3(.3, .3, 0)
