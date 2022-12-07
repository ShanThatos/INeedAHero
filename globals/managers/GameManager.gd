extends Node

var level_manager = null
var voxel_manager = null
var nav_manager = null

var is_scene_loaded := false
signal scene_loaded

var is_vr_enabled := false

func _ready():
	yield(get_tree().get_root(), "ready")
	is_scene_loaded = true
	emit_signal("scene_loaded")

func _process(_delta: float):
	if Input.is_action_just_pressed("exit_game"):
		get_tree().quit()
