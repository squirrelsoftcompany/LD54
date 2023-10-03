extends MeshInstance3D


var materials := {
	Color.BLUE			 : preload("res://resources/CountryMaterial/blue.tres"),
	Color.CYAN			 : preload("res://resources/CountryMaterial/cyan.tres"),
	Color.DEEP_PINK		 : preload("res://resources/CountryMaterial/deeppink.tres"),
	Color.GOLD			 : preload("res://resources/CountryMaterial/gold.tres"),
	Color.GREEN_YELLOW	 : preload("res://resources/CountryMaterial/greenyellow.tres"),
	Color.ORANGE 		 : preload("res://resources/CountryMaterial/orange.tres"),
	Color.REBECCA_PURPLE : preload("res://resources/CountryMaterial/rebeccapurple.tres"),
	Color.RED			 : preload("res://resources/CountryMaterial/red.tres")
}

var annoyed_time : float = ProjectSettings.get_setting("specific/meeple/annoyed_time", 1)
var anger_time : float = ProjectSettings.get_setting("specific/meeple/anger_time", 1)
var vanish_time : float = ProjectSettings.get_setting("specific/meeple/vanish_time", 1)
var happy_time : float = ProjectSettings.get_setting("specific/meeple/happy_time", 5)

@export var country_color: Color = Color.BLACK
@export var country_id: int = -1

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
	var _country_under_meeple := CountryPicker.country_under_unprojected_3d_position(global_position)
	
	match _state:
		State.ONBOARD:
			wait = max(0,floor(wait-delta))
			if not is_in_train:
				_state = State.WAITING
			elif _country_under_meeple == country_id:
				assert(_current_drop_slot.is_in_group("Wagon"))
				_current_drop_slot.dragged_out(self)
				_SpawnerManager._country_spawner[_country_under_meeple].pushMeeple(self)
				is_in_train = false
		State.HAPPY_TO_BE_ONBOARD:
			wait = max(0,floor(wait-delta))
			happy += delta
			if not is_in_train:
				_state = State.WAITING
			elif _country_under_meeple == country_id:
				_state = State.ARRIVED
			elif happy >= happy_time:
				_state = State.ONBOARD
		State.WAITING:
			wait += delta
			if is_in_train:
				_state = State.ONBOARD
			elif _country_under_meeple == country_id:
				_state = State.ARRIVED
			elif wait >= annoyed_time :
				_state = State.ANNOYED
		State.ANNOYED:
			wait += delta
			if is_in_train:
				_state = State.ONBOARD
			elif _country_under_meeple == country_id:
				_state = State.ARRIVED
			elif wait >= anger_time :
				_state = State.ANGERED
		State.ANGERED:
			wait += delta
			if is_in_train:
				_state = State.HAPPY_TO_BE_ONBOARD
			elif _country_under_meeple == country_id:
				_state = State.ARRIVED
			elif wait >= vanish_time :
				happy = 0.0
				_state = State.VANISHING
		State.VANISHING, State.ARRIVED:
			if is_in_train and _state == State.VANISHING:
				scale = Vector3.ONE
				_state = State.HAPPY_TO_BE_ONBOARD
			elif scale.length() > delta:
				scale -= Vector3.ONE * delta
				bubble.scale = scale.inverse()
			else:
				if (_current_drop_slot.is_in_group("Spawner")
				and _current_drop_slot.has_method("takeMeeple")):
					_current_drop_slot.takeMeeple(self)
				visible = false
				if _Dragger._dragged_object == self:
					_Dragger._dragged_object_ghost = null
					_Dragger._dragged_object = null
					if ghost: ghost.queue_free()
				if _state == State.VANISHING : _Global.add_meeple_gone()
				else : _Global.add_meeple_arrived()
				queue_free.call_deferred()

	update_speech()


func setCountry(_country_id : int) -> void:
	country_id = _country_id
	country_color = CountryPicker.country_to_color(country_id)
	var material = materials[Color.RED]
	for key in materials.keys():
		if key.is_equal_approx(country_color):
			material = materials[key]
			break

	set_material_override(material)


var ghost : Node3D = null
func drag_begin():
	RenderingServer.global_shader_parameter_set("destination_color", country_color)
	RenderingServer.global_shader_parameter_set("highlighted_color", CountryPicker.color_under_unprojected_3d_position(global_position))
	if not ghost:
		ghost = self.duplicate(0)
		get_tree().root.add_child(ghost)
		ghost.get_node("StaticBody3D").queue_free() # remove bounding box
	return ghost


func drag_finished(droppable):
	_current_drop_slot = droppable
	is_in_train = _current_drop_slot and _current_drop_slot.is_in_group("Wagon")
	drag_cancelled(droppable)


func drag_finished_in_void(picked_position : Vector3):
	var country_under_mouse := CountryPicker.country_under_unprojected_3d_position(picked_position)
	assert(country_under_mouse != -1)
	_current_drop_slot.dragged_out(self)
	drag_finished(_SpawnerManager._country_spawner[country_under_mouse])
	_current_drop_slot.dropped_in(self)


func can_drag():
	return _state != State.VANISHING && _state != State.ARRIVED


func can_drop(droppable, picked_position : Vector3) -> bool:
	var country_under_me := CountryPicker.country_under_unprojected_3d_position(global_position)
	var country_droppable : int
	if droppable:
		country_droppable = CountryPicker.country_under_unprojected_3d_position(droppable.global_position)
	else:
		assert(picked_position.is_finite())
		country_droppable = CountryPicker.country_under_unprojected_3d_position(picked_position)
	invalid_placement = country_under_me != country_droppable or country_droppable == -1
	if droppable && droppable.has_method("can_drop"):
		invalid_placement = invalid_placement || not droppable.can_drop(self, picked_position)
	return country_under_me == country_droppable and country_droppable != -1


func drag_cancelled(_droppable):
	if ghost: ghost.queue_free()
	ghost = null
	RenderingServer.global_shader_parameter_set("destination_color", Color.BLACK)
	RenderingServer.global_shader_parameter_set("highlighted_color", Color.BLACK)


@onready var _current_drop_slot := get_parent()
func current_drop_slot():
	return _current_drop_slot


func update_speech():
	if ghost:
		var ghost_bubble := ghost.get_node("./SpeechBubble") as AnimatedSprite3D
		ghost_bubble.frame = 3
		ghost_bubble.visible = invalid_placement
	
	match _state:
		State.HAPPY_TO_BE_ONBOARD, State.ARRIVED:
			bubble.visible = true
			bubble.frame = 0
			bubble.modulate = Color.WHITE
		State.ANNOYED :
			bubble.visible = true
			bubble.frame = 1
			bubble.modulate = Color.WHITE
		State.ANGERED :
			bubble.visible = true
			bubble.frame = 2
			bubble.modulate = Color.WHITE
		State.VANISHING :
			bubble.visible = true
			bubble.frame = 2
			bubble.modulate = Color.RED
		_:
			bubble.visible = false
