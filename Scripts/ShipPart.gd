extends Area2D
class_name ShipPart

var working := true:
	set(value):
		toggled.emit(value)
		working = value

@export var interactTime := 10.0

var player : Player = null
var playerInteracting := false

var timer : Timer

static var UI = preload("res://Scenes/interactible_ui.tscn")

var uiInstance : InteractibleUI = null

@onready var collisionShape: CollisionShape2D = $CollisionShape2D

@export var alarm : Sprite2D
static var alarmSpeed := 5.0
static var hasElectricity := true

signal toggled

func _ready() -> void:
	body_entered.connect(bodyEntered)
	body_exited.connect(bodyExited)
	
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = interactTime
	timer.timeout.connect(interactFinished)

func bodyEntered(body : Node2D):
	if body is Player:
		player = body
		
		if not working:
			uiInstance = UI.instantiate()
			uiInstance.position = Vector2.ZERO
			collisionShape.add_child(uiInstance)

func bodyExited(body : Node2D):
	if body is Player:
		player.interacting = false
		playerInteracting = false
		timer.stop()
		
		if uiInstance:
			uiInstance.queue_free()
			uiInstance = null
		
		player = null

func interactFinished():
	working = true
	
	if alarm:
		alarm.rotation = 0.0
	
	player.interacting = false
	playerInteracting = false
	timer.stop()
	
	uiInstance.queue_free()
	uiInstance = null

func _process(delta: float) -> void:
	if alarm:
		if not working and hasElectricity:
			alarm.visible = true
			alarm.rotate(alarmSpeed * delta)
		else:
			alarm.visible = false
	
	if player and Input.is_action_just_pressed("Interact") and not working:
		player.interacting = true
		playerInteracting = true
		timer.start()
	
	if player and Input.is_action_just_released("Interact") and playerInteracting:
		player.interacting = false
		playerInteracting = false
		timer.stop()
	
	if uiInstance: 
		if timer:
			uiInstance.progress_bar.value = timer.wait_time - timer.time_left
			uiInstance.progress_bar.max_value = timer.wait_time
		else:
			uiInstance.progress_bar.value = 0
			uiInstance.progress_bar.max_value = 1
