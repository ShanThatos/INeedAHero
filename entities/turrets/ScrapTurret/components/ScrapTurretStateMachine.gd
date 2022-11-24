extends StateMachine
class_name ScrapTurretStateMachine

func preload_states():
    return FileUtils.load_scripts(["ScrapTurretTargetState"], FileUtils.get_script_base_dir(self))
