extends Node
var mainCamera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mainCamera = get_tree().root.get_camera_3d()
	pass # Replace with function body.


func _physics_process(_delta):
	var cursor = mainCamera.get_viewport().get_mouse_position()
	var viewportSize = mainCamera.get_viewport().get_visible_rect().size
	if cursor.x >= 0 and cursor.x < viewportSize.x and cursor.y >= 0 and cursor.y < viewportSize.y:
		var image = get_viewport().get_texture().get_image()
		var _color = image.get_pixelv(cursor)
		#print(color) # Print for debug
