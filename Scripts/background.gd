extends Sprite2D

@export var repeatSize : Vector2

func _process(_delta: float) -> void:
	position.x = fmod(position.x, repeatSize.x)
	position.y = fmod(position.y, repeatSize.y)
