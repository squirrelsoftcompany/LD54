extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func _on_night_day_pressed():
	get_tree().call_group("environement","day_night")


func _on_texture_button_toggled(button_pressed):
	pass
