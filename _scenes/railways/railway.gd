@tool
extends Path3D


@export var reset_y := true
@export var reset_tilt := true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		connect("curve_changed", on_curve_changed)
	pass # Replace with function body.


var wip := false
func on_curve_changed():
	if (not reset_y and not reset_tilt) or wip or not Engine.is_editor_hint():
		return

	wip = true
	for i in curve.point_count:
		if reset_y:
			var pin = curve.get_point_in(i)
			var pout = curve.get_point_out(i)
			var point = curve.get_point_position(i)
			curve.set_point_in(i, Vector3(pin.x, 0, pin.z))
			curve.set_point_out(i, Vector3(pout.x, 0, pout.z))
			curve.set_point_position(i, Vector3(point.x, 0, point.z))
		if reset_tilt:
			curve.set_point_tilt(i, 0)

	#prints(curve.resource_path, "reset")
	wip = false
