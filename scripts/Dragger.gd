extends Node


var ps_offset_dragged_object : Vector3 = ProjectSettings.get_setting("specific/dragger/dragged/offset", Vector3.ZERO)
var ps_draggable_flags : int = ProjectSettings.get_setting("specific/dragger/dragged/draggable_flags", 1)
var ps_droppable_flags : int = ProjectSettings.get_setting("specific/dragger/dragged/droppable_flags", 2)
const RAY_LENGTH := 2000
const CLICK_THRESHOLD := 200


@onready var mainCamera : Camera3D = get_viewport().get_camera_3d()


var _dragging := false
var _dragging_since := 0
var _from := Vector3.INF
var _dir := Vector3.INF
var _to := Vector3.INF
var _dragged_object : Node3D = null
var _dragged_object_ghost : Node3D = null
func _unhandled_input(event: InputEvent) -> void:
	mainCamera = get_viewport().get_camera_3d()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# begin drag
		if _dragging and not event.pressed and _dragged_object and Time.get_ticks_msec() - _dragging_since <= CLICK_THRESHOLD:
			_dragging = false
			on_click(_dragged_object)
			_dragged_object = null
			_dragged_object_ghost = null
			_droppable_under_mouse = null
		elif _dragging and not event.pressed:
			_dragging = false
			if (_droppable_under_mouse and _dragged_object):
				dragged_out(current_drop_slot(_dragged_object), _dragged_object)
				drag_finished(_dragged_object, _droppable_under_mouse)
				dropped_in(_droppable_under_mouse, _dragged_object)
			elif (_drop_in_void_allowed and _dragged_object):
				dragged_out(current_drop_slot(_dragged_object), _dragged_object)
				drag_finished_in_void(_dragged_object, _dragging_3d_position)
			elif _dragged_object: drag_cancelled(_dragged_object)
			_dragged_object = null
			_dragged_object_ghost = null
			_droppable_under_mouse = null
		# end drag
		elif not _dragging and event.pressed:
			_dragging = true
			_dragging_since = Time.get_ticks_msec()
			_dragged_object = _draggable_under_mouse
			_dragged_object_ghost = drag_begin(_dragged_object)
	elif event is InputEventMouse:
		var mouse_position : Vector2 = event.global_position
		_from = mainCamera.project_ray_origin(mouse_position)
		_dir = mainCamera.project_ray_normal(mouse_position)
		_to = _from + _dir * RAY_LENGTH


func _process(_delta: float) -> void:
	move_dragged_object()


func _physics_process(_delta: float) -> void:
	update_under_mouse()


var _draggable_under_mouse : Node3D = null
var _droppable_under_mouse : Node3D = null
var _dragging_3d_position : Vector3 = Vector3.INF
var _drop_in_void_allowed := false
func update_under_mouse():
	if not _from.is_finite() or not _to.is_finite():
		_draggable_under_mouse = null
		_droppable_under_mouse = null
		_dragging_3d_position = Vector3.INF
		return
	
	var space_state = get_viewport().get_world_3d().direct_space_state
	if not _dragged_object:
		# draggable
		var query = PhysicsRayQueryParameters3D.create(_from, _to, ps_draggable_flags)
		var result = space_state.intersect_ray(query)
		_draggable_under_mouse = result.get("collider", null)
		if _draggable_under_mouse:
			if can_drag(_draggable_under_mouse):
				_draggable_under_mouse = _draggable_under_mouse.get_parent()
			else: _draggable_under_mouse = null
		else:
			_draggable_under_mouse = null
		# drop
		_droppable_under_mouse = null
	else:
		# ground
		var distance = (ps_offset_dragged_object.y - _from.y)/_dir.y
		_dragging_3d_position = _from + _dir * distance + Vector3(ps_offset_dragged_object.x, 0, ps_offset_dragged_object.z)
		# droppable
		var query_drop = PhysicsRayQueryParameters3D.create(_from, _to, ps_droppable_flags)
		var result_drop = space_state.intersect_ray(query_drop)
		var candidate_droppable = result_drop.get("collider", null)
		if candidate_droppable:
			candidate_droppable = candidate_droppable.get_parent()
			if can_drop(_dragged_object, candidate_droppable, _dragging_3d_position):
				_droppable_under_mouse = candidate_droppable
			else: _droppable_under_mouse = null
			_drop_in_void_allowed = false
		else:
			_droppable_under_mouse = null
			_drop_in_void_allowed = can_drop(_dragged_object, null, _dragging_3d_position)
		# drag
		_draggable_under_mouse = null


func move_dragged_object():
	if _dragged_object_ghost:
		if _dragging_3d_position.is_finite():
			_dragged_object_ghost.global_position = _dragging_3d_position
		_dragged_object_ghost.visible = Time.get_ticks_msec() - _dragging_since >= CLICK_THRESHOLD


#utils
func current_drop_slot(draggable : Node3D) -> Node3D:
	return _generic_drop("current_drop_slot", draggable, [], null)
func can_drag(draggable : Node3D) -> bool:
	return _generic_drop("can_drag", draggable, [], true)
func can_drop(draggable : Node3D, droppable : Node3D, picked_position : Vector3) -> bool:
	return _generic_drop("can_drop", draggable, [droppable,picked_position], true) and _generic_drop("can_drop", droppable, [draggable,picked_position], true)
func dropped_in(droppable : Node3D, draggable : Node3D) -> void:
	_generic_drop("dropped_in", droppable, [draggable], null)
func dragged_out(droppable : Node3D, draggable : Node3D) -> void:
	_generic_drop("dragged_out", droppable, [draggable], null)
func drag_finished(draggable : Node3D, droppable : Node3D) -> void:
	_generic_drop("drag_finished", draggable, [droppable], null)
func drag_finished_in_void(draggable : Node3D, picked_position : Vector3) -> void:
	_generic_drop("drag_finished_in_void", draggable, [picked_position], null)
func drag_begin(draggable : Node3D) -> Node3D:
	return _generic_drop("drag_begin", draggable, [], draggable)
func drag_cancelled(draggable : Node3D) -> void:
	_generic_drop("drag_cancelled", draggable, [null], null)
func on_click(draggable : Node3D) -> void:
	_generic_drop("on_click", draggable, [null], null)
func _generic_drop(method_name : String, caller : Node3D, args : Array, default_value):
	if caller and caller.has_method(method_name):
		#prints(method_name, "on", caller.name)
		if not args.is_empty(): return caller.callv(method_name, args)
		else: return caller.call(method_name)
	elif caller and caller.get_parent() and caller.get_parent().has_method(method_name):
		#prints(method_name, "on", caller.get_parent().name)
		if not args.is_empty(): return caller.get_parent().callv(method_name, args)
		else: return caller.get_parent().call(method_name)
	@warning_ignore("incompatible_ternary")
	return default_value
