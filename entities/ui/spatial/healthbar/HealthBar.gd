tool
extends Node
class_name HealthBar

export(NodePath) 	var progress_bar_path
export(bool) 		var show_when_full = true
export(bool) 		var is_billboard = true setget set_is_billboard, get_is_billboard

var progress_bar: ProgressBar

func _ready():
	progress_bar = get_node(progress_bar_path)
	self.visible = show_when_full
	set_health_bar(1)

func set_health_bar(health: float):
	progress_bar.value = health
	self.visible = show_when_full or health < 1

func set_is_billboard(_is_billboard: bool):
	is_billboard = _is_billboard
	var sprite: Sprite3D = get_node_or_null("Sprite3D")
	print(sprite)
	if sprite:
		sprite.billboard = 2 if is_billboard else 0

func get_is_billboard() -> bool:
	return is_billboard