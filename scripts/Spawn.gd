extends Node3D


@onready var ps_meeple_offset : float = ProjectSettings.get_setting("specific/meeple/offset", 1) # m
@onready var ps_meeple_spawn_time : float = ProjectSettings.get_setting("specific/meeple/spawn_time", 1) # s


@export var maxMeeple : int = 10
@export var meepleByRow = 5


@onready var spawnTimer : Timer = get_node("SpawnTimer")


var meepleClass = preload("res://_scenes/nodes/meeple.tscn")
var meepleArray : Array[Node3D] = []
#Debug var ------------------
var triggerable = true
#----------------------------


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnTimer.wait_time = ps_meeple_spawn_time
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

		pushMeeple(meeple)
	else:
		#TODO : send message to game controler to trigger game over
		print("Max meeple capacity reached") #Debug print
		spawnTimer.stop()


func takeMeeple(pMeeple:Node3D) -> void :
	var searchedMeepleIndex := find_meeple(pMeeple)
	if searchedMeepleIndex != -1:
		meepleArray.remove_at(searchedMeepleIndex)
		updateMeeplePosition() 


func pushMeeple(pMeeple:Node3D) -> void:
	if find_meeple(pMeeple) != -1: return
	if not pMeeple.get_parent(): add_child(pMeeple, true, Node.INTERNAL_MODE_BACK)
	else: pMeeple.reparent(self)
	meepleArray.push_back(pMeeple)
	updateMeeplePosition()


func find_meeple(pMeeple:Node3D) -> int:
	var searchedMeepleIndex := -1
	for i in range(0, meepleArray.size()):
		if pMeeple.get_instance_id() == meepleArray[i].get_instance_id():
			searchedMeepleIndex = i
	return searchedMeepleIndex


func updateMeeplePosition() -> void :
	for i in range(0, meepleArray.size()):
		@warning_ignore("integer_division")
		meepleArray[i].position.x = (i%meepleByRow) * ps_meeple_offset
		@warning_ignore("integer_division")
		meepleArray[i].position.z = (i/meepleByRow) * ps_meeple_offset
		# reset rotation
		meepleArray[i].rotation.y = 0


func _on_spawn_timer_timeout() -> void:
	spawnMeeple()
	pass # Replace with function body.


func get_size() -> Vector2:
	@warning_ignore("integer_division")
	return Vector2(meepleByRow, maxMeeple/meepleByRow) * ps_meeple_offset


func dragged_out(meeple:Node3D):
	takeMeeple(meeple)


func dropped_in(meeple:Node3D):
	pushMeeple(meeple)
