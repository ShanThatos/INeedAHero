extends Spatial

var ground_material: SpatialMaterial

func _ready():
	ground_material = $MeshInstance.get_active_material(0)
	scale_to(scale.x, scale.z)

func scale_to(x_scale: float, z_scale: float):
	scale.x = x_scale
	scale.z = z_scale
	ground_material.uv1_scale.x = x_scale
	ground_material.uv1_scale.z = z_scale
