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
	if (Time.get_ticks_msec()/1000)%6 == 0:
		triggerable = true
	if (Time.get_ticks_msec()/1000)%6 == 5 and triggerable:
		if meepleArray.size() > 2:
			takeMeeple(meepleArray[2])
		triggerable = false
	# -----------------------------------------------
	pass

func spawnMeeple() -> void :
	if meepleArray.size() < maxMeeple:
		
		var placeHolderMeeple = meepleClass.instantiate()
		placeHolderMeeple.setCountry(Color(1.0,0.0,0.0,1.0))
		placeHolderMeeple.transform.origin = transform.origin
	
		add_child(placeHolderMeeple)
		meepleArray.push_back(placeHolderMeeple)
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
		meepleArray[i].position.x = (i%meepleByRow)*0.2
		meepleArray[i].position.z = (i/meepleByRow)*0.2

func _on_spawn_timer_timeout() -> void:
	spawnMeeple()
	pass # Replace with function body.
