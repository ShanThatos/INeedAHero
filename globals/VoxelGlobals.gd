class_name VoxelGlobals

const VOXEL_DATA = {
    "Base": {
        "scene": preload("res://entities/voxels/blocks/Base.tscn"),
        "size": Vector3(3, 2, 3),
        "breakable": false
    },
    "ScrapBlock": {
        "scene": preload("res://entities/voxels/blocks/ScrapBlock.tscn"),
        "size": Vector3(1, 1, 1),
        "breakable": true
    },
    "ScrapRamp": {
        "scene": preload("res://entities/voxels/blocks/ScrapRamp.tscn"),
        "size": Vector3(1, 1, 1),
        "breakable": true,
        "mesh": "Ramp"
    }
}
