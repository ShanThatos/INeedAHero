class_name ItemGlobals

enum ItemType {
    NONE, 
    BULLDOZER, 
    SCRAP_BLOCK, 
    BASE,
    SCRAP
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
    ItemType.SCRAP_BLOCK: {
        "name": "Scrap Block",
        "action": ItemAction.PLACE,
        "cost": 2,
        "texture": "ScrapBlock.jpg",
        "text_display": "-{cost}"
    },
    ItemType.BASE: {
        "name": "Base",
        "action": ItemAction.PLACE,
        "cost": 0
    },
    ItemType.SCRAP: {
        "name": "Scrap",
        "action": ItemAction.NONE,
        "texture": "scrap.png",
        "text_display": "{amount} scrap"
    }
}