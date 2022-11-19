extends StateMachine
class_name GruntStateMachine

func preload_states():
    return FileUtils.load_scripts(["GruntIdleState"], FileUtils.get_script_base_dir(self))