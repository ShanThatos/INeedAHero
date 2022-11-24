extends Area
class_name VRButtonClicker

func _ready():
    var _ignore = connect("area_entered", self, "_on_area_entered")
    _ignore = connect("area_exited", self, "_on_area_exited")

func _on_area_entered(area: Area):
    if area is VRButton:
        area.clicker_entered = true

func _on_area_exited(area: Area):
    if area is VRButton:
        area.clicker_entered = false
