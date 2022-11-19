

GODOT := bin/Godot_v3.5.1-stable_win64.exe
GODOT_PROJECT := ./


run:
	$(GODOT) --path $(GODOT_PROJECT)

edit:
	$(GODOT) --path $(GODOT_PROJECT) -e

