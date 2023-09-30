extends MeshInstance3D

var blueMat = preload("res://resources/CountryMaterial/blue.tres")
var cyanMat = preload("res://resources/CountryMaterial/cyan.tres")
var deeppinkMat = preload("res://resources/CountryMaterial/deeppink.tres")
var goldMat = preload("res://resources/CountryMaterial/gold.tres")
var greenyellowMat = preload("res://resources/CountryMaterial/greenyellow.tres")
var orangeMat = preload("res://resources/CountryMaterial/orange.tres")
var rebeccapurpleMat = preload("res://resources/CountryMaterial/rebeccapurple.tres")
var redMat = preload("res://resources/CountryMaterial/red.tres")

@export var country: Color



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

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
