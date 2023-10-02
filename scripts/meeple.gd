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
var happy_time : float = ProjectSettings.get_setting("specific/meeple/happy_time", 5)

@export var country: Color

var wait = 0.0
var happy = 0.0
var invalid_placement = false
var is_in_train = false
var bubble = AnimatedSprite3D

enum State{
	WAITING,
	ONBOARD,
	HAPPY_TO_BE_ONBOARD,
	ANNOYED,
	ANGERED,
	VANISHING,
	ARRIVED
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bubble = $SpeechBubble


var _state : State = State.WAITING
var _previous_state : State = State.WAITING
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_previous_state = _state
	
	match _state:
		State.ONBOARD:
			wait = max(0,floor(wait-delta/1000))
			if not is_in_train:
				_state = State.WAITING
		State.HAPPY_TO_BE_ONBOARD:
			wait = max(0,floor(wait-delta/1000))
			happy += delta
			if not is_in_train:
				_state = State.WAITING
			elif happy >= happy_time:
				_state = State.ONBOARD
		State.WAITING:
			wait += delta
			if is_in_train:
				_state = State.ONBOARD
			elif wait >= annoyed_time :
				_state = State.ANNOYED
		State.ANNOYED:
			wait += delta
			if is_in_train:
				_state = State.ONBOARD
			elif wait >= anger_time :
				_state = State.ANGERED
		State.ANGERED:
			wait += delta
			if is_in_train:
				_state = State.HAPPY_TO_BE_ONBOARD
			elif wait >= vanish_time :
				happy = 0.0
				_state = State.VANISHING
		State.VANISHING:
			if scale.length() > delta:
				scale -= Vector3.ONE * delta
				bubble.scale = scale.inverse()
			else:
				if (_current_drop_slot.is_in_group("Spawner")
				and _current_drop_slot.has_method("takeMeeple")):
					get_parent().takeMeeple(self)
				visible = false
				if _Dragger._dragged_object == self:
					_Dragger._dragged_object_ghost = null
					_Dragger._dragged_object = null
					if ghost: ghost.queue_free()
				var currentGoneMeeple = ProjectSettings.get_setting("specific/level/meeple_gone")
				ProjectSettings.set_setting("specific/level/meeple_gone", currentGoneMeeple+1)
				if (currentGoneMeeple+1 == ProjectSettings.get_setting("specific/level/meeple_gone_max")):
					_Global.trigger_game_over()
				queue_free()

	update_speech()


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
func drag_begin():
	if not ghost:
		ghost = self.duplicate(0)
		get_tree().root.add_child(ghost)
	return ghost


func drag_finished(droppable):
	if ghost: ghost.queue_free()
	ghost = null
	_current_drop_slot = droppable
	is_in_train = _current_drop_slot and _current_drop_slot.is_in_group("Wagon")


func can_drag():
	return _state != State.VANISHING


func can_drop(droppable) -> bool:
	var country_droppable := CountryPicker.country_under_unprojected_3d_position(droppable.global_position)
	var country_draggable := CountryPicker.country_under_unprojected_3d_position(self.global_position)
	invalid_placement = not (country_draggable == country_droppable and country_droppable != -1)
	return not invalid_placement


func drag_cancelled(_droppable):
	if ghost: ghost.queue_free()
	ghost = null


@onready var _current_drop_slot := get_parent()
func current_drop_slot():
	return _current_drop_slot


func update_speech():
	if ghost:
		var ghost_bubble := ghost.get_node("./SpeechBubble") as AnimatedSprite3D
		ghost_bubble.frame = 3
		ghost_bubble.visible = invalid_placement
	
	match _state:
		State.HAPPY_TO_BE_ONBOARD:
			bubble.visible = true
			bubble.frame = 0
		State.ANNOYED :
			bubble.visible = true
			bubble.frame = 1
		State.ANGERED, State.VANISHING :
			bubble.visible = true
			bubble.frame = 2
		_:
			bubble.visible = false
