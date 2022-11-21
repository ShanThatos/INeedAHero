extends Node
class_name XRManager

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

