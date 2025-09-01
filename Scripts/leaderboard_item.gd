extends Control
class_name LeaderBoardItem

func setup(scoreName : String, score : int):
	$Name.text = scoreName
	$Score.text = str(str(float(score)/1000.0).pad_decimals(1), "km")
