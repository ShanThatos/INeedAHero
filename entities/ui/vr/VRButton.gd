extends Area
class_name VRButton

signal _on_vrbutton_press

export(float)   var clicker_time := 3.0
var clicker_entered := false
var clicker_time_left := 0.0

onready var mesh_indicator: MeshInstance = $CollisionShape/MeshInstance

func _ready():
    pass

func _process(delta: float):
    if clicker_entered:
        clicker_time_left -= delta
        if clicker_time_left <= 0:
            clicker_entered = false
            emit_signal("_on_vrbutton_press")
    if !clicker_entered:
        clicker_time_left = clicker_time
    mesh_indicator.scale = Vector3.ONE * clicker_time_left / clicker_time
