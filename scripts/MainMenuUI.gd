extends Control

@export var bipSound : AudioStreamPlayer
@export var quitButton : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Hide quit button for web support (useless)
	if OS.has_feature("web"): 
		quitButton.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	bipSound.play()
	# Change scene


func _on_quit_button_pressed() -> void:
	get_tree().quit()
