extends MarginContainer

@onready var mute = ProjectSettings.get_setting("specific/sound/mute")
@onready var day_night = ProjectSettings.get_setting("specific/environment/day_night")

func _ready():
	$VBoxContainer/Sound.button_pressed = mute
	$VBoxContainer/NightDay.button_pressed = day_night
	if get_parent().name == "MainMenu" :
		$VBoxContainer/NightDay.visible = false


func _on_night_day_pressed():
	day_night = !day_night
	ProjectSettings.set_setting("specific/environment/day_night",day_night)
	get_tree().call_group("environement","day_night")


func _on_sound_toggled(button_pressed):
	mute = button_pressed
	ProjectSettings.set_setting("specific/sound/mute",mute)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), mute)
