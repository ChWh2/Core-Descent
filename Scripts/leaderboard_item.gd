extends Control
class_name LeaderBoardItem

func setup(scoreName : String, score : int):
	$Name.text = scoreName
	$Score.text = str(score, "km")
