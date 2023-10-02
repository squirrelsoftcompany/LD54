extends MeshInstance3D


var blueMat = preload("res://resources/CountryMaterial/blue.tres")
var cyanMat = preload("res://resources/CountryMaterial/cyan.tres")
var deeppinkMat = preload("res://resources/CountryMaterial/deeppink.tres")
var goldMat = preload("res://resources/CountryMaterial/gold.tres")
var greenyellowMat = preload("res://resources/CountryMaterial/greenyellow.tres")
var orangeMat = preload("res://resources/CountryMaterial/orange.tres")
var rebeccapurpleMat = preload("res://resources/CountryMaterial/rebeccapurple.tres")
var redMat = preload("res://resources/CountryMaterial/red.tres")

var annoyed_time : float = ProjectSettings.get_setting("specific/meeple/annoyed_time", 1)
var anger_time : float = ProjectSettings.get_setting("specific/meeple/anger_time", 1)
var vanish_time : float = ProjectSettings.get_setting("specific/meeple/vanish_time", 1)

@export var country: Color

var wait = 0.0
var invalid_placement = false
var is_in_train = false
var bubble = AnimatedSprite3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bubble = $SpeechBubble


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var state = 0
	
	if is_in_train:
		wait =floor(wait-delta/1000)
	else:
		wait += delta
		if wait <= annoyed_time :
			state = 0
		elif wait > annoyed_time and wait < anger_time:
			state = 1
		else :
			state = 2
	update_speech(state)
	if wait > vanish_time:
		self.visible = false
		# TO DO : loss condition

func getCountry() -> Color:
	return country

func setCountry(pCountry : Color) -> void:
	var material
	if pCountry.is_equal_approx(Color.BLUE):
		material = blueMat.duplicate()
	elif pCountry.is_equal_approx(Color.CYAN):
		material = cyanMat.duplicate()
	elif pCountry.is_equal_approx(Color.DEEP_PINK):
		material = deeppinkMat.duplicate()
	elif pCountry.is_equal_approx(Color.GOLD):
		material = goldMat.duplicate()
	elif pCountry.is_equal_approx(Color.GREEN_YELLOW):
		material = greenyellowMat.duplicate()
	elif pCountry.is_equal_approx(Color.ORANGE):
		material = orangeMat.duplicate()
	elif pCountry.is_equal_approx(Color.REBECCA_PURPLE):
		material = rebeccapurpleMat.duplicate()
	elif pCountry.is_equal_approx(Color.RED):
		material = redMat.duplicate()
	else:
		material = redMat.duplicate()
	
	set_material_override(material)


var ghost : Node3D = null
func drag_begin(_droppable):
	if not ghost:
		ghost = self.duplicate(0)
		get_tree().root.add_child(ghost)
	return ghost


func drag_finished(_droppable):
	if ghost: ghost.queue_free()
	ghost = null
	
	# when inside wagon, there isn't any takeMeeple function
	var _spawner := get_parent()
	if (_spawner.has_method("takeMeeple")):
		_spawner.takeMeeple(self)


func can_drop(droppable) -> bool:
	var country_droppable := CountryPicker.country_under_unprojected_3d_position(droppable.global_position)
	var country_draggable := CountryPicker.country_under_unprojected_3d_position(self.global_position)
	return (country_draggable == country_droppable and country_droppable != -1)


func drag_cancelled(_droppable):
	if ghost: ghost.queue_free()
	ghost = null

func update_speech(state):
	if is_in_train:
		if state == 2 :
			bubble.visible = true
			bubble.frame = 0
	elif invalid_placement:
		bubble.visible = true
		bubble.frame = 3
	elif state == 1 :
		bubble.visible = true
		bubble.frame = 1
	elif state == 2 :
		bubble.visible = true
		bubble.frame = 2
	else :
		bubble.visible = false
