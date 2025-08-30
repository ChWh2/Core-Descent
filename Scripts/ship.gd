extends Node2D
class_name Ship

const maxSpeed := 1000.0
const acceleration := 100.0

const startingShipDamage := 15.0
const endingShipDamage := 5.0
const baseShipDamage := 0.9
var brokenShipParts := 0
@onready var timer: Timer = $"../Timer"

var swivelSpeed := 1.0
var speed := 0.0

signal toggleOxygen

@onready var navigation: ShipPart = $Navigation
@onready var oxygen: ShipPart = $Oxygen
@onready var electric: ShipPart = $Electric
@onready var engine: ShipPart = $Engine

var shipPartArray : Array[ShipPart]

@onready var background: ParallaxBackground = $Background

func _ready() -> void:
	shipPartArray.append(navigation)
	shipPartArray.append(oxygen)
	shipPartArray.append(electric)
	shipPartArray.append(engine)
	
	timer.wait_time = 15.0
	timer.start()
	timer.timeout.connect(timeout)
	
	oxygen.toggled.connect(func(): toggleOxygen.emit())

func _process(delta: float) -> void:
	if not navigation.working:
		var swivel : float = 0.0
	
		if rotation != 0:
			swivel = rotation / abs(rotation)
		else:
			swivel = randi_range(0, 1) * 2.0 - 1.0
		
		swivel = swivel * swivelSpeed * delta * 0.05
		
		rotate(swivel)
		rotation = clamp(rotation, -PI/2.0, PI/2.0)
	else:
		var newRotation : float = move_toward(rotation, 0.0, swivelSpeed * delta * 0.05)
		rotation = newRotation
	
	if not engine.working:
		$Fire.emitting = false
		speed -= acceleration * delta
	else:
		$Fire.emitting = true
		speed += acceleration * delta
	speed = clamp(speed, 0.0, maxSpeed)
	GameManager.distance += speed * delta
	
	ShipPart.hasElectricity = electric.working
	
	background.offset -= speed * Vector2(-sin(rotation), cos(rotation)) * delta

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
