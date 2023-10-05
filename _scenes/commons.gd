@tool
extends Node3D

@export var goal : int = ProjectSettings.get_setting("specific/level/meeple_arrived_max")

# Called when the node enters the scene tree for the first time.
func _ready():
	ProjectSettings.set_setting("specific/level/meeple_arrived_max",goal)
