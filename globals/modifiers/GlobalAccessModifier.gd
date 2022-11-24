extends Node
class_name GlobalAccessModifier

export(String)  var global_id := ""

func _ready():
    assert(global_id != "", "global_id is not set %s" % str(self))
    var key = global_id
    assert(!(key in GameManager.get_meta_list()), "GlobalAccessModifier: global_id '%s' already exists" % global_id)
    GameManager.set_meta(key, self)
