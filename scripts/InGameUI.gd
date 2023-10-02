extends Control

@export var arrivedMeepleScore : Label
@export var goneMeepleScore : Label
@export var summaryTitle : Label
@export var summaryButton : Button
@export var levelSummary : Panel
@export var bip_sound : AudioStreamPlayer

var currentArrivedMeeple
var currentArrivedMeepleMax
var currentGoneMeeple
var currentGoneMeepleMax


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_Global.connect("update_ui",_on_update_ui)
	_Global.connect("level_complet",_on_level_complet)
	_Global.connect("game_over",_on_game_over)
	_Global.call_update_ui()
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
	arrivedMeepleScore.text = str(currentArrivedMeeple) + "/" + str(currentArrivedMeepleMax)
	goneMeepleScore.text = str(currentGoneMeeple) + "/" + str(currentGoneMeepleMax)

func _on_game_over() -> void:
	summaryTitle.text = "GAME OVER"
	summaryButton.text = "Retry"
	levelSummary.visible = true
	pass

func _on_level_complet() -> void:
	summaryTitle.text = "Well Played"
	summaryButton.text = "Next"
	levelSummary.visible = true
	pass


func _on_continue_pressed() -> void:
	bip_sound.play()
	levelSummary.visible = false
