extends Node
class_name GlobalAccessModifier

export(String)  var global_id := ""
export(bool)    var multiple := false

func _ready():
    assert(global_id != "", "global_id is not set %s" % str(self))
    var key = global_id
    var exists = key in GameManager.get_meta_list()
    if multiple:
        if !exists:
            GameManager.set_meta(key, [])
        GameManager.get_meta(key).append(self)
    else:
        assert(!exists, "GlobalAccessModifier: global_id '%s' already exists" % global_id)
        GameManager.set_meta(key, self)
