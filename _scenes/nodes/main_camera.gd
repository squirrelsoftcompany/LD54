@tool
extends Camera3D


@export var direction := Vector3(0, 7, 2)
@export var hotspot := Vector3(0, 0, 0)
@export var distance := 10.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var ndir := direction.normalized()
	position = hotspot + ndir * distance
	transform = transform.looking_at(position - ndir)
