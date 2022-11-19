class_name FileUtils


static func get_all_files(path: String, file_ext := "", files := []) -> Array:
    var dir = Directory.new()
    assert(dir.open(path) == OK, "Cannot open directory: " + path)
    
    dir.list_dir_begin(true, true)
    var file_name = dir.get_next()
    while file_name != "":
        if dir.current_is_dir():
            files = get_all_files(dir.get_current_dir().plus_file(file_name), file_ext, files)
        elif file_name.get_extension() == file_ext:
            files.append(dir.get_current_dir().plus_file(file_name))
        file_name = dir.get_next()
    
    return files

static func find_script(script_name: String, directory := "res://") -> String:
    var files = get_all_files(directory, "gd")
    for file in files:
        if file.ends_with(script_name + ".gd"):
            return file
    assert(false, "Script not found: " + script_name)
    return ""

static func load_scripts(scripts: Array, directory := "res://") -> Array:
    var loaded_scripts = []
    for script in scripts:
        loaded_scripts.append(load(find_script(script, directory)))
    return loaded_scripts

static func get_script_base_dir(obj: Object) -> String:
    var script = obj.get_script()
    assert(script != null, "Object %s has no script" % str(obj))
    return script.get_path().get_base_dir()