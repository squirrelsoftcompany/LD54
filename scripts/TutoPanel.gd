extends Panel

@export var previousButton : Button
@export var nextButton : Button
@export var quitButton : Button
@export var tutoPage_0 : TextureRect
@export var tutoPage_1 : TextureRect
@export var tutoPage_2 : TextureRect
@export var clickSound : AudioStreamPlayer

var currentPage = 0
var maxPages = 2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previousButton.disabled = true
	currentPage = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func updatePage() -> void:
	if currentPage == 0:
		tutoPage_0.visible = true
		tutoPage_1.visible = false
		tutoPage_2.visible = false
	elif currentPage == 1:
		tutoPage_0.visible = false
		tutoPage_1.visible = true
		tutoPage_2.visible = false
	elif currentPage == 2:
		tutoPage_0.visible = false
		tutoPage_1.visible = false
		tutoPage_2.visible = true
	else:
		print("We should not be here")


func _on_next_pressed() -> void:
	clickSound.play()
	currentPage = currentPage+1
	previousButton.disabled = false
	if currentPage == maxPages:
		nextButton.disabled = true
	updatePage()
	


func _on_previous_pressed() -> void:
	clickSound.play()
	currentPage = currentPage-1
	nextButton.disabled = false
	if currentPage == 0:
		previousButton.disabled = true
	updatePage()


func _on_exit_tuto_pressed() -> void:
	self.visible = false
	currentPage = 0
