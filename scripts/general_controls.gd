extends MarginContainer

var mute = ProjectSettings.get_setting("specific/sound/mute")

func _ready():
	$VBoxContainer/Sound.button_pressed = mute
	if get_parent().name == "MainMenu" :
		$"../AudioStreamPlayer".stream_paused = mute
		$VBoxContainer/NightDay.visible = false
		
func _on_night_day_pressed():
	get_tree().call_group("environement","day_night")

func _on_sound_toggled(button_pressed):
	print(mute)
	mute = button_pressed
	ProjectSettings.set_setting("specific/sound/mute",mute)
	get_tree().call_group("MainCam","sound")
	if get_parent().name == "MainMenu" :
		$"../AudioStreamPlayer".stream_paused = mute
