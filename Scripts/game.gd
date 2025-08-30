extends Node2D
class_name GameManager

const maxOxygen := 30.0
var oxygen := maxOxygen
var oxygenDrain := false

@onready var player: Player = $Player
@onready var ship: Ship = $Ship

static var distance := 0.0

func _ready() -> void:
	ship.toggleOxygen.connect(toggleOxygen)

func _process(delta: float) -> void:
	if oxygenDrain:
		oxygen -= delta
	
	$Player/UI/Oxygen.max_value = maxOxygen
	$Player/UI/Oxygen.value = oxygen
	$Player/UI/Distance.text = str("Distance: ", floor(GameManager.distance / 100.0) /10.0, "km")

func toggleOxygen():
	oxygenDrain = not oxygenDrain
	oxygen = maxOxygen
