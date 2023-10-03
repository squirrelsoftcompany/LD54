extends Node3D


@onready var ps_meeple_offset : float = ProjectSettings.get_setting("specific/meeple/offset", 1) # m
@onready var ps_meeple_spawn_time : float = ProjectSettings.get_setting("specific/meeple/spawn_time", 1) # s


@export var maxMeeple : int = 10
@export var meepleByRow = 5
@export_enum(
	"INVALID:-1","BLUE:0","CYAN:1","DEEP_PINK:2","GOLD:3",
	"GREEN_YELLOW:4","ORANGE:5","REBECCA_PURPLE:6","RED:7"
	) var country_id := -1


@onready var spawnTimer : Timer = get_node("SpawnTimer")


var meepleClass = preload("res://_scenes/nodes/meeple.tscn")
var meepleArray : Array[Node3D] = []
var country_color : Color


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnTimer.wait_time = ps_meeple_spawn_time
	_SpawnerManager.register_spawner(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func spawnMeeple() -> void :
	if meepleArray.size() < maxMeeple:
		var meeple = meepleClass.instantiate()
		#Spawner currently use every colors, we should create a smarter function to randomly choose a color available for the current level
		var countriesAvailable : Array = _SpawnerManager._country_spawner.keys()
		countriesAvailable.erase(country_id)
		meeple.setCountry(countriesAvailable[randi_range(0, countriesAvailable.size()-1)])
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
	assert(pMeeple)
	if find_meeple(pMeeple) != -1: return
	if not pMeeple.get_parent(): add_child(pMeeple, true, Node.INTERNAL_MODE_BACK)
	else: pMeeple.reparent(self)
	meepleArray.push_back(pMeeple)
	updateMeeplePosition()


func find_meeple(pMeeple:Node3D) -> int:
	var searchedMeepleIndex := -1
	for i in range(0, meepleArray.size()):
		if pMeeple == meepleArray[i]:
			searchedMeepleIndex = i
	return searchedMeepleIndex


func updateMeeplePosition() -> void :
	for i in range(0, meepleArray.size()):
		if not meepleArray[i]:
			continue
		@warning_ignore("integer_division")
		meepleArray[i].position.x = (i%meepleByRow) * ps_meeple_offset
		@warning_ignore("integer_division")
		meepleArray[i].position.z = (i/meepleByRow) * ps_meeple_offset
		# reset position
		meepleArray[i].position.y = 0
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
