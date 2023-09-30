extends MeshInstance3D

@export var country: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func getCountry(pCountry : Color) -> void:
	country = pCountry

func setCountry(pCountry : Color) -> void:
	country = pCountry
	var material = get_surface_override_material(0)
	material.albedo_color = country
