extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Snap the node to the main camera transform. Sufficient as long as the main camera remains fixed
	var mainCamera = get_tree().root.find_child("MainCamera",true,false)
	transform = mainCamera.transform
	pass # Replace with function body.



