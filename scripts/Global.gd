extends Node

signal update_ui
signal level_complet
signal level_loaded
signal game_over

var _current_scene = null
var _current_scene_res = null
var _main_menu := preload("res://_scenes/menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_current_scene = get_tree().get_root().get_child(2)
	_current_scene_res = _main_menu
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func call_update_ui() -> void:
	emit_signal("update_ui")


func pause() -> void:
	Engine.set_time_scale(0)


func resume() -> void:
	Engine.set_time_scale(1)
	
	
func trigger_game_over() -> void:
	emit_signal("game_over")
	
	
func trigger_level_complet() -> void:
	emit_signal("level_complet")


func show_menu() -> void:
	_goto_scene(_main_menu)
	
	
func goto_next_level():
	goto_level(ProjectSettings.get_setting("specific/level/current") + 1)


func goto_level(index):
	var levels : Array = ProjectSettings.get_setting("specific/level/list")
	if index < 0 or index >= levels.size():
		return
	ProjectSettings.set_setting("specific/level/current", index)
	_goto_scene(load(levels[index]))


func reload_level():
	goto_level(ProjectSettings.get_setting("specific/level/current"))
	
	
func _goto_scene(scene: Resource) -> void:
	# Defer the load to a later time, when
	# we can be sure that no code from the current scene is running
	call_deferred("_deferred_goto_scene", scene)


func _deferred_goto_scene(scene: Resource) -> void:
	# Remove the current scene
	if _current_scene:
		_current_scene.free()

	# Instance the new scene.
	_current_scene = scene.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(_current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(_current_scene)
	
	# Reinit global data
	reinit()


func reinit():
	pass
	#ProjectSettings.set_setting("Specific/Level/InProgress", false)
