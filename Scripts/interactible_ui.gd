extends Control
class_name InteractibleUI

@onready var label: Label = $Label
@onready var progress_bar: ProgressBar = $ProgressBar

func _process(_delta: float) -> void:
	rotation = -get_parent().global_rotation
