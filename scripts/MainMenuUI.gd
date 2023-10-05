extends Control

@export var bipSound : AudioStreamPlayer
@export var quitButton : Button
var mute = ProjectSettings.get_setting("specific/sound/mute")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Hide quit button for web support (useless)
	if OS.has_feature("web"): 
		quitButton.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	mute = ProjectSettings.get_setting("specific/sound/mute")
	if not mute:
		bipSound.play()
	_Global.goto_level(0)
	


func _on_quit_button_pressed() -> void:
	get_tree().quit()
