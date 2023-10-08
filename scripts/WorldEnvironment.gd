extends WorldEnvironment
var mode = ProjectSettings.get_setting("shader_globals/day_night").value
var looks = self.environment


func day_night ():
	if mode:
		RenderingServer.global_shader_parameter_set("day_night",false)
		mode = false
		looks.background_color = Color(0.07,0.07,0.07)
		looks.ambient_light_energy = 0.2
		looks.ambient_light_color = Color(0.325, 0.494, 1)
	else:
		RenderingServer.global_shader_parameter_set("day_night",true)
		mode = true
		looks.background_color = Color.WHITE_SMOKE
		looks.ambient_light_energy = 0.5
		looks.ambient_light_color = Color.WHITE
