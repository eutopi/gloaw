extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	$TimerLabel.hide()
	$GreyscaleShader.hide()
	$RestartButton.hide()
	$HomeButton.hide()
	$ScoreLabel.hide()
	$WinningScoreLabel.hide()
	$Leaderboard.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_StartButton_pressed():
	$TimerLabel.show()
	$StartButton.hide()
	$LeaderboardButton.hide()
	$TitleLabel.hide()
	$InstructionsLabel.hide()
	$ScoreLabel.show()
	$StartButton/StartSound.play()
	$StartButton/StartMusic.stop()
	emit_signal("start_game")

func _on_RestartButton_pressed():
	$TimerLabel.show()
	$MusicBox.stop()
	$RestartButton.hide()
	$RestartButton/RestartSound.play()
	$HomeButton.hide()
	$ScoreLabel.show()
	$GreyscaleShader.hide()
	$WinningScoreLabel.hide()
	emit_signal("start_game")

func _on_LeaderboardButton_pressed():
	$StartButton.hide()
	$LeaderboardButton.hide()
	$TitleLabel.hide()
	$InstructionsLabel.hide()
	$StartButton/StartSound.play()
	$BackButton.show()
	$Leaderboard.show()
	var places_array = [$Leaderboard/PlaceLabel1, $Leaderboard/PlaceLabel2, $Leaderboard/PlaceLabel3, $Leaderboard/PlaceLabel4, $Leaderboard/PlaceLabel5]
	var stats = get_parent().load_game()
	var top_five = stats.keys()
	top_five.sort()
	var range_num = 5
	if top_five.size() < 5:
		range_num = top_five.size()
	for i in range(range_num):
		places_array[i].text = str(i+1) + ') ' + stats[top_five[i]] + '     ' + str(top_five[i])

func _on_HomeButton_pressed():
	_ready()
	$MusicBox.stop()
	$RestartButton/RestartSound.play()
	$TitleLabel.show()
	$InstructionsLabel.show()
	$StartButton.show()
	$LeaderboardButton.show()
	$StartButton/StartMusic.play()
	$Leaderboard.hide()

func _on_BackButton_pressed():
	_ready()
	$RestartButton/RestartSound.play()
	$TitleLabel.show()
	$InstructionsLabel.show()
	$StartButton.show()
	$LeaderboardButton.show()
	$BackButton.hide()
	$Leaderboard.hide()