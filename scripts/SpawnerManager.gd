extends Node


var _country_spawner : Dictionary = {}


func register_spawner(_spawner:Node3D):
	assert(_spawner.country_id != -1)
	_spawner.country_color = CountryPicker.country_to_color(_spawner.country_id)
	_country_spawner[_spawner.country_id] = _spawner
	_spawner.connect("tree_exiting", spawner_exiting.bind(_spawner))


func spawner_exiting(_spawner):
	_country_spawner.erase(_spawner.country_id)
