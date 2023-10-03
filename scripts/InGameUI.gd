extends Control

@export var arrivedMeepleScore : Label
@export var goneMeepleScore : Label
@export var summaryArrivedMeepleScore : Label
@export var summaryGoneMeepleScore : Label
@export var summaryTitle : Label
@export var summaryButton : Button
@export var levelSummary : Panel
@export var tutoPanel : Panel
@export var bip_sound : AudioStreamPlayer

var currentArrivedMeeple
var currentArrivedMeepleMax
var currentGoneMeeple
var currentGoneMeepleMax
var gameOver : bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_Global.connect("update_ui",_on_update_ui)
	_Global.connect("level_complete",_on_level_complete)
	_Global.connect("game_over",_on_game_over)
	_Global.call_update_ui()
	
	# Hide/show tutorial
	var index = ProjectSettings.get_setting("specific/level/current")
	if index == 0:
		tutoPanel.visible = true
		_Global.pause()
	else:
		tutoPanel.visible = false
		_Global.resume()
	gameOver = false
#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_update_ui() -> void:
	currentArrivedMeeple = ProjectSettings.get_setting("specific/level/meeple_arrived")
	currentArrivedMeepleMax = ProjectSettings.get_setting("specific/level/meeple_arrived_max")
	currentGoneMeeple = ProjectSettings.get_setting("specific/level/meeple_gone")
	currentGoneMeepleMax = ProjectSettings.get_setting("specific/level/meeple_gone_max")
	arrivedMeepleScore.text = str(currentArrivedMeeple) + "/" + str(currentArrivedMeepleMax)
	goneMeepleScore.text = str(currentGoneMeeple) + "/" + str(currentGoneMeepleMax)
	summaryArrivedMeepleScore.text = str(currentArrivedMeeple) + "/" + str(currentArrivedMeepleMax)
	summaryGoneMeepleScore.text = str(currentGoneMeeple) + "/" + str(currentGoneMeepleMax)


func _on_game_over() -> void:
	_on_update_ui()
	_Global.pause()
	summaryTitle.text = "GAME OVER"
	summaryButton.text = "Retry"
	levelSummary.visible = true
	gameOver = true


func _on_level_complete() -> void:
	_on_update_ui()
	_Global.pause()
	var levels : Array = ProjectSettings.get_setting("specific/level/list")
	if (ProjectSettings.get_setting("specific/level/current")) >= 6 :
		summaryTitle.text = "Game complete. Congratulations"
		summaryButton.text = "Menu"
	else:
		summaryTitle.text = "Well Played"
		summaryButton.text = "Next"
	levelSummary.visible = true
	

func _on_continue_pressed() -> void:
	bip_sound.play()
	levelSummary.visible = false
	if gameOver:
		gameOver = false
		_Global.reload_level()
	else:
		_Global.goto_next_level()
	
