extends Node

var level_manager = null
var voxel_manager = null
var nav_manager = null

func _process(_delta: float):
	if Input.is_action_just_pressed("exit_game"):
		get_tree().quit()

func start_game():
	var XR = ARVRServer.find_interface("OpenXR")
	if XR and (XR.interface_is_initialized or XR.initialize()):
		get_tree().change_scene("res://entities/levels/VRLevel.tscn")
	else:
		get_tree().change_scene("res://entities/levels/MainLevel.tscn")

