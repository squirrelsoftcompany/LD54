extends SubViewport
class_name CountryPicker


static var countryArray : PackedColorArray = ProjectSettings.get_setting("Game/countryArray", [])


static var color_under_mouse : Color
static var country_under_mouse : int
static var mainCamera : Camera3D
static var last_image : Image
static var last_image_rect : Rect2i
static var viewport_rect : Rect2i


@export var _color_under_mouse : Color
@export var _country_under_mouse : int = -1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mainCamera = get_tree().root.get_camera_3d()
	mainCamera.get_viewport().connect("size_changed", on_main_viewport_size_changed)
	on_main_viewport_size_changed()


func _process(_delta: float) -> void:
	if _image_updating and _frames_drawn < Engine.get_frames_drawn():
		_image_updating = false
		render_target_update_mode = SubViewport.UPDATE_DISABLED
		# retrieve last image
		last_image = get_texture().get_image()
		if last_image:
			last_image_rect = Rect2i(Vector2i.ZERO, last_image.get_size())
		else:
			last_image_rect = Rect2i()
	pass


func _physics_process(_delta):
	# get color/country under mouse
	var cursor = mainCamera.get_viewport().get_mouse_position()
	_color_under_mouse = CountryPicker.color_under_position(cursor)
	_country_under_mouse = CountryPicker.color_to_country(_color_under_mouse)
	color_under_mouse = _color_under_mouse
	country_under_mouse = _country_under_mouse


static func color_under_position(position : Vector2):
	if viewport_rect.has_point(position) and last_image and last_image_rect.has_point(position):
		return last_image.get_pixelv(position)
	else:
		return Color.BLACK


func on_main_viewport_size_changed():
	viewport_rect = mainCamera.get_viewport().get_visible_rect()
	get_parent().size = mainCamera.get_viewport().size
	ask_for_update()


var _image_updating := true
var _frames_drawn := 0
func ask_for_update():
	render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_image_updating = true
	_frames_drawn = Engine.get_frames_drawn()


#utils
static func country_under_unprojected_3d_position(position_3d : Vector3) -> int:
	return CountryPicker.color_to_country(color_under_unprojected_3d_position(position_3d))
static func color_under_unprojected_3d_position(position_3d : Vector3) -> Color:
	var position := mainCamera.unproject_position(position_3d)
	return CountryPicker.color_under_position(position)
static func country_under_position(position : Vector2) -> int:
	return CountryPicker.color_to_country(color_under_position(position))
static func color_to_country(color : Color) -> int:
	for i in countryArray.size():
		var dist_sq = (Vector3(countryArray[i].r, countryArray[i].g, countryArray[i].b)
				.distance_squared_to(Vector3(color.r, color.g, color.b)))
		if dist_sq < 0.01:
			return i
	return -1
static func country_to_color(country : int):
	assert(country != -1)
	return countryArray[country]
