@tool
extends Node3D


@export var group_to_snap_to := "MainCam"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	var snap_to = get_tree().get_first_node_in_group(group_to_snap_to)
	if snap_to:
		transform = snap_to.transform
