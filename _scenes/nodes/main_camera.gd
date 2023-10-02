@tool
extends Camera3D


@export var direction := Vector3(0, 7, 2)
@export var hotspot := Vector3(0, 0, 0)
@export var distance := 10.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	compute_transform()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): compute_transform()


func compute_transform():
	var ndir := direction.normalized()
	position = hotspot + ndir * distance
	transform = transform.looking_at(position - ndir)
