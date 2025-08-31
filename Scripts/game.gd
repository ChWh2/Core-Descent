extends Node2D
class_name GameManager

const maxOxygen := 30.0
var oxygen := maxOxygen
var oxygenDrain := false

@onready var player: Player = $Player
@onready var ship: Ship = $Ship

static var distance := 0.0

@onready var sceneSwitcher: SceneSwitcher = $SceneSwitcher

func _ready() -> void:
	distance = 0.0
	ship.toggleOxygen.connect(toggleOxygen)

func _process(delta: float) -> void:
	if oxygenDrain:
		oxygen -= delta
	else:
		oxygen += delta
	
	oxygen = clamp(oxygen, 0.0, maxOxygen)
	if oxygen == 0.0:
		sceneSwitcher.switch()
	
	$Player/UI/Oxygen.max_value = maxOxygen
	$Player/UI/Oxygen.value = oxygen
	$Player/UI/Distance.text = str("Distance: ", floor(distance / 100.0) /10.0, "km")

func toggleOxygen(value : bool):
	oxygenDrain = not value
