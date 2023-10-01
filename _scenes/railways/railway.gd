@tool
extends Path3D

@export var reset_y := true
@export var reset_tilt := true
var visual_elements_interval : float = ProjectSettings.get_setting("specific/rail/visual_elements_interval", 1)
var visual_rail = Node3D
var visual_elements = MultiMesh
var start_visual = Node3D
var end_visual = Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visual_elements = $RailDecoration.multimesh
	start_visual = $EndOfLine
	end_visual = $EndOfLine2
	visual_rail = $Rail
	update_multimesh()
	if Engine.is_editor_hint():
		connect("curve_changed", on_curve_changed)
	pass # Replace with function body.

var wip := false
func on_curve_changed():
	update_multimesh()
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

func update_multimesh ():
	var path_length = curve.get_baked_length()
	var count = floor(path_length/visual_elements_interval)
	visual_elements.instance_count = count
	var distance = visual_elements_interval/2
	
	for i in range(0,count):
		var place = Transform3D(Basis(),curve.sample_baked(distance,true))
		visual_elements.set_instance_transform(i,place)
		distance += visual_elements_interval
	
	var start = curve.get_point_position(0)
	var end = curve.get_point_position(curve.point_count-1)
	if start.distance_to(end) > 10.0:
		start_visual.transform.origin = start 
		start_visual.look_at(curve.sample_baked(0.2))
		end_visual.transform.origin = end
		end_visual.look_at(curve.sample_baked(path_length-0.2))
		start_visual.visible = true
		end_visual.visible = true
		visual_rail.path_joined = false
	else:
		start_visual.visible = false
		end_visual.visible = false
		visual_rail.path_joined = true
