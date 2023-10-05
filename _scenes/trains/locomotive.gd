extends Node3D
var mute = ProjectSettings.get_setting("specific/sound/mute")

func _process(delta):
	mute = ProjectSettings.get_setting("specific/sound/mute")
	$AudioStreamPlayer3D.stream_paused = mute
