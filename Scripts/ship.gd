extends StaticBody2D
class_name Ship

const maxSpeed := 10.0
const acceleration := 1.0

var swivelSpeed := 1.0
var speed := 1.0

var brokenNavigation := false
var brokenEngine := false
var brokenGenerator := false
var brokenOxygenFilter := false

func _process(delta: float) -> void:
	if brokenNavigation:
		var swivel : float = 0.0
	
		if rotation != 0:
			swivel = rotation / abs(rotation)
		else:
			swivel = randi_range(0, 1) * 2.0 - 1.0
		
		swivel = swivel * swivelSpeed * delta * 0.05
		
		rotate(swivel)
		rotation = clamp(rotation, -PI/2.0, PI/2.0)
	
	if brokenEngine:
		speed -= acceleration * delta
	else:
		speed += acceleration * delta
	speed = clamp(speed, 0.0, maxSpeed)
	
	if brokenGenerator:
		pass
	
	if brokenOxygenFilter:
		pass
