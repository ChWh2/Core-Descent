extends VBoxContainer

@export var leaderboardItem : PackedScene

func _ready() -> void:
	await SilentwolfManager.updateScores()
	var Scores : Array = SilentwolfManager.scores
	
	for result in Scores:
		var score : LeaderBoardItem = leaderboardItem.instantiate()
		add_child(score)
		score.setup(result.get("player_name"), int(result.get("score")))
