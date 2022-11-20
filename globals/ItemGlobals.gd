class_name ItemGlobals

enum ItemType {
    NONE, 
    BULLDOZER, 
    SCRAP,
    BASE,
    SCRAP_BLOCK,
    SCRAP_RAMP
}

enum ItemAction {
    NONE, 
    PLACE,
    BULLDOZE
}

const ITEM_DATA = {
    ItemType.NONE: {
        "name": "None",
        "action": ItemAction.NONE
    },
    ItemType.BULLDOZER: {
        "name": "Bulldozer",
        "action": ItemAction.BULLDOZE,
        "texture": "bulldoze.png",
        "text_display": "destroy"
    },
    ItemType.SCRAP: {
        "name": "Scrap",
        "action": ItemAction.NONE,
        "texture": "scrap.png",
        "text_display": "{amount} scrap"
    },
    ItemType.BASE: {
        "name": "Base",
        "action": ItemAction.PLACE,
        "voxel_name": "Base",
        "cost": 0
    },
    ItemType.SCRAP_BLOCK: {
        "name": "Scrap Block",
        "action": ItemAction.PLACE,
        "voxel_name": "ScrapBlock",
        "cost": 2,
        "texture": "ScrapBlock.jpg",
        "text_display": "-{cost}"
    },
    ItemType.SCRAP_RAMP: {
        "name": "Scrap Ramp",
        "action": ItemAction.PLACE,
        "voxel_name": "ScrapRamp",
        "cost": 2,
        "texture": "ScrapRamp.png",
        "text_display": "-{cost}"
    }
}