extends Entity
class_name VoxelEntity

const ItemGlobals = preload("res://globals/ItemGlobals.gd")
const ItemType = ItemGlobals.ItemType

export(ItemType) var entity_type = ItemType.NONE
export(Vector3) var voxel_size = Vector3.ZERO
export(bool) var breakable = true       # may not appear when extracted from state