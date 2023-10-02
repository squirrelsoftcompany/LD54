extends Control

@export var arrivedMeepleScore : Label
@export var goneMeepleScore : Label

var currentArrivedMeeple
var currentArrivedMeepleMax
var currentGoneMeeple
var currentGoneMeepleMax


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_Global.connect("update_ui",_on_update_ui)
	#_Global.connect("update_ui",Callable(self, "_on_update_ui"))
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_update_ui() -> void:
	currentArrivedMeeple = ProjectSettings.get_setting("specific/level/meeple_arrived")
	currentArrivedMeepleMax = ProjectSettings.get_setting("specific/level/meeple_arrived_max")
	currentGoneMeeple = ProjectSettings.get_setting("specific/level/meeple_gone")
	currentGoneMeepleMax = ProjectSettings.get_setting("specific/level/meeple_gone_max")
	arrivedMeepleScore.text = str(currentArrivedMeeple + "/" + currentArrivedMeepleMax)
	goneMeepleScore.text = str(currentGoneMeeple + "/" + currentGoneMeepleMax)
	

