extends Node
var mainCamera : Camera3D


@export var color_under_mouse : Color


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mainCamera = get_tree().root.get_camera_3d()
	pass # Replace with function body.


func _physics_process(_delta):
	var cursor = mainCamera.get_viewport().get_mouse_position()
	var rect := mainCamera.get_viewport().get_visible_rect()
	if rect.has_point(cursor):
		var image = get_viewport().get_texture().get_image()
		color_under_mouse = image.get_pixelv(cursor)
	else:
		color_under_mouse = Color.BLACK
