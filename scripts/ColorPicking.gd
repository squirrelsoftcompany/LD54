extends Node
var mainCamera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mainCamera = get_tree().root.find_child("MainCamera",true,false)
	pass # Replace with function body.

	
func _physics_process(_delta):
	var cursor = mainCamera.get_viewport().get_mouse_position()
	var image = get_viewport().get_texture().get_image()
	var color = image.get_pixelv(cursor)
	#print(color) # Print for debug
