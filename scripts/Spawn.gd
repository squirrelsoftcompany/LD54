extends Node3D

var meepleClass = preload("res://_scenes/nodes/meeple.tscn")

var meepleByRow = 5 
var meepleArray : Array[Node3D] = []

@onready var spawnTimer = get_node("SpawnTimer")
@export var maxMeeple : int

#Debug var ------------------
var triggerable = true
#----------------------------

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#Debug : Test the takeMeeple() function -----------
	@warning_ignore("integer_division")
	var modul_time = Time.get_ticks_msec()/1000
	if modul_time == 0:
		triggerable = true
	elif modul_time == 5 and triggerable:
		if meepleArray.size() > 2:
			takeMeeple(meepleArray[2])
		triggerable = false
	# -----------------------------------------------
	pass

func spawnMeeple() -> void :
	if meepleArray.size() < maxMeeple:
		
		var meeple = meepleClass.instantiate()
		var countryArray = ProjectSettings.get_setting("Game/countryArray")
		#Spawner currently use every colors, we should create a smarter function to randomly choose a color available for the current level
		meeple.setCountry(countryArray[randi()%7+1])
		meeple.transform.origin = transform.origin
	
		add_child(meeple)
		meepleArray.push_back(meeple)
		updateMeeplePosition()
	else:
		#TODO : send message to game controler to trigger game over
		print("Max meeple capacity reached") #Debug print
		spawnTimer.stop()

func takeMeeple(pMeeple:Node3D) -> Node3D :
	var searchedMeepleIndex
	for i in range(0, meepleArray.size()):
		if pMeeple.get_instance_id() == meepleArray[i].get_instance_id():
			searchedMeepleIndex = i
	meepleArray.remove_at(searchedMeepleIndex)
	updateMeeplePosition()
	return 

func updateMeeplePosition() -> void :
	for i in range(0, meepleArray.size()):
		@warning_ignore("integer_division")
		meepleArray[i].position.x = (i%meepleByRow)*0.2
		@warning_ignore("integer_division")
		meepleArray[i].position.z = (i/meepleByRow)*0.2

func _on_spawn_timer_timeout() -> void:
	spawnMeeple()
	pass # Replace with function body.
