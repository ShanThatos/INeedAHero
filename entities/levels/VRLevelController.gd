extends Node
class_name VRLevelController

const vr_button_scene = preload("res://entities/ui/vr/VRButton.tscn")
const level_manager_scene = preload("res://globals/managers/LevelManager.tscn")
const ground_scene = preload("res://entities/voxels/ground/Ground.tscn")
const vr_inventory_scene = preload("res://entities/ui/vr/VRInventory.tscn")
const vr_player_scene = preload("res://entities/player/VRPlayer.tscn")

onready var xr_origin: ARVROrigin = $ARVROrigin
onready var main_label: Label3D = $MainLabel

var main_vr_button: Spatial = null

func _ready():
	var vp = get_viewport()
	vp.arvr = true
	OS.vsync_enabled = false
	Engine.target_fps = 90
	var config_gdns = load("res://addons/godot-openxr/config/OpenXRConfig.gdns")
	var xr_config = config_gdns.new()
	vp.transparent_bg = true
	xr_config.start_passthrough()

	Gizmos.stroke = .1
	start_level_initialization()

func start_level_initialization():
	yield(get_tree().create_timer(1.0), "timeout")
	ARVRServer.center_on_hmd(ARVRServer.RESET_BUT_KEEP_TILT, true)

	main_vr_button = vr_button_scene.instance()
	main_vr_button.scale = Vector3.ONE * .1
	add_child(main_vr_button)
	main_vr_button.visible = false

	yield(get_tree().create_timer(2.0), "timeout")

	var left_index_tip: Spatial = GameManager.get_meta("left_index_tip")

	Gizmos.lifetime = 10000
	Gizmos.color = Gizmos.WHITE

	main_label.text = "Place left hand index finger at\nthe top left corner of the table"
	main_vr_button.visible = true

	yield(main_vr_button, "_on_vrbutton_press")
	var top_left_pos := left_index_tip.global_translation
	main_label.text = "Good!"
	main_vr_button.visible = false

	Gizmos.create_line(top_left_pos, top_left_pos + Vector3.UP * .1)

	yield(get_tree().create_timer(2.0), "timeout")
	main_label.text = "Now top right corner of the table"
	main_vr_button.visible = true

	yield(main_vr_button, "_on_vrbutton_press")
	var top_right_pos := left_index_tip.global_translation
	main_label.text = "Good!"
	main_vr_button.visible = false

	Gizmos.create_line(top_right_pos, top_right_pos + Vector3.UP * .1)

	yield(get_tree().create_timer(2.0), "timeout")
	main_label.text = "Now bottom left corner of the table"
	main_vr_button.visible = true

	yield(main_vr_button, "_on_vrbutton_press")
	var bottom_left_pos := left_index_tip.global_translation
	main_label.text = "Good!"
	main_vr_button.visible = false

	Gizmos.clear_gizmos()

	var average_y = (top_left_pos.y + top_right_pos.y + bottom_left_pos.y) / 3.0
	average_y -= .01
	top_left_pos.y = average_y
	top_right_pos.y = average_y
	bottom_left_pos.y = average_y

	var tl_to_tr = top_right_pos - top_left_pos
	# making the table rectanglish
	var tl_to_bl = bottom_left_pos - top_left_pos
	tl_to_bl = tl_to_bl - tl_to_bl.project(tl_to_tr)
	bottom_left_pos = top_left_pos + tl_to_bl

	var left_edge_length = tl_to_bl.length()
	var top_edge_length = tl_to_tr.length()

	var level_scale = max(.02, min(left_edge_length, top_edge_length) / 40.0)
	
	var level = level_manager_scene.instance()
	level.scale = Vector3.ONE * level_scale

	var ground = ground_scene.instance()
	ground.scale = Vector3(top_edge_length / level_scale, 1, left_edge_length / level_scale)
	ground.name = "Ground"
	level.add_child(ground)

	add_child(level)
	level.global_translation = (top_right_pos + bottom_left_pos) / 2.0
	level.look_at((top_left_pos + top_right_pos) / 2.0, Vector3.UP)

	var inventory = vr_inventory_scene.instance()
	var inventory_length = max(.3, top_edge_length)
	inventory.scale = Vector3.ONE * (inventory_length / level_scale)
	level.add_child(inventory)
	inventory.global_translation = bottom_left_pos + tl_to_tr / 2 + tl_to_bl.normalized() * .02

	var player = vr_player_scene.instance()
	level.add_child(player)

	var inventory_component = player.get_component("InventoryComponent")
	var num_inventory_buttons = inventory_component.items.size()
	for i in range(1, num_inventory_buttons + 1):
		var item_button = vr_button_scene.instance()
		item_button.scale = Vector3.ONE * .05
		item_button.translation = Vector3((i - .5) / num_inventory_buttons - .5, 0, 0)
		inventory.add_child(item_button)
		item_button.connect("_on_vrbutton_press", inventory_component, "set_current_item", [i - 1])

func _process(_delta: float):
	if main_vr_button != null:
		var left_index_tip: Spatial = GameManager.get_meta("left_index_tip")
		main_vr_button.global_translation = left_index_tip.global_translation + Vector3(.3, .3, 0)
