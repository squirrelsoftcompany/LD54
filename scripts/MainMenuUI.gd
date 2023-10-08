extends Control

@export var bipSound : AudioStreamPlayer
@export var quitButton : Button


@onready var mute = ProjectSettings.get_setting("specific/sound/mute")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Hide quit button for web support (useless)
	if OS.has_feature("web"):
		quitButton.visible = false
	
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), mute)


func _on_start_button_pressed() -> void:
	_Global.goto_level(0)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
