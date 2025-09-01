extends Node

var scores : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var file = FileAccess.open("res://SiletWolfAPI.txt", FileAccess.READ)
	var key = file.get_line()
	
	SilentWolf.configure({
		"api_key": key,
		"game_id": "coredescent",
		"log_level": -1
	})

func updateScores():
	var sw_result = await SilentWolf.Scores.get_scores(9).sw_get_scores_complete
	scores = sw_result.scores
