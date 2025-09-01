extends CharacterBody2D
class_name Player

const SPEED = 75.0
const JUMP_VELOCITY = -250.0

var interacting := false

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		sprite_2d.animation = "Fall"
	
	if not interacting:
		# Handle jump.
		if Input.is_action_just_pressed("Up") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction and not interacting:
		velocity.x = direction * SPEED
		if is_on_floor():
			sprite_2d.animation = "Walk"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			sprite_2d.animation = "default"

	move_and_slide()
