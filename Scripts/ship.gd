extends Node2D
class_name Ship

const startingShipDamage := 15.0
const endingShipDamage := 5.0
const baseShipDamage := 0.9
var brokenShipParts := 0
@onready var timer: Timer = $"../Timer"

var swivelSpeed := 1.0
var swivelDirection := 0

const maxSpeed := 1000.0
const acceleration := 100.0
var speed := 0.0

signal toggleOxygen

@onready var navigation: ShipPart = $Navigation
@onready var oxygen: ShipPart = $Oxygen
@onready var electric: ShipPart = $Electric
@onready var engine: ShipPart = $Engine
var shipPartArray : Array[ShipPart]

@onready var background: Sprite2D = $Background

func _ready() -> void:
	shipPartArray.append(navigation)
	shipPartArray.append(oxygen)
	shipPartArray.append(electric)
	shipPartArray.append(engine)
	
	timer.wait_time = 15.0
	timer.start()
	timer.timeout.connect(timeout)
	
	oxygen.toggled.connect(func(value : bool): toggleOxygen.emit(value))

func _process(delta: float) -> void:
	if not navigation.working:
		var swivel : float = 0.0
	
		if swivelDirection == 0:
			swivelDirection = int(randi_range(0, 1) * 2.0 - 1.0)
		
		swivel = swivelDirection * swivelSpeed * delta * 0.05
		
		rotate(swivel)
		rotation = wrap(rotation, -PI, PI)
	else:
		var newRotation : float = move_toward(rotation, 0.0, swivelSpeed * delta * 0.05)
		swivelDirection = 0
		rotation = newRotation
	
	if not engine.working:
		$Fire.emitting = false
		speed -= acceleration * delta
	else:
		$Fire.emitting = true
		speed += acceleration * delta
	speed = clamp(speed, 0.0, maxSpeed)
	
	GameManager.distance += speed * cos(rotation) * delta
	
	ShipPart.hasElectricity = electric.working
	
	background.position.y -= speed * delta
	background.rotation = -rotation

func timeout():
	var randMax := 1.0
	for i in brokenShipParts:
		randMax += 0.5
	randMax = floor(randMax)
	
	var partsToBreakCount := randi_range(1, int(randMax))
	var partsToBreak : Array[ShipPart]
	
	for i in partsToBreakCount:
		var randomPart : ShipPart = shipPartArray.pick_random()
		if partsToBreak.find(randomPart) == -1:
			partsToBreak.append(randomPart)
		
	for i in partsToBreak:
		i.working = false
	
	print(str("broke ", partsToBreak))
	
	timer.wait_time = float(partsToBreak.size()) * ((startingShipDamage - endingShipDamage) * pow(baseShipDamage, float(brokenShipParts)) + endingShipDamage)
	timer.start()
	
	brokenShipParts += partsToBreak.size()
