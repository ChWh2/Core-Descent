extends Node
class_name SceneSwitcher

@export var path : String = "res://Scenes/main_menu.tscn"

func switch():
	get_tree().change_scene_to_file(path)
