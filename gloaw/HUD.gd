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
	pass # Replace with function body.

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

func _on_HomeButton_pressed():
	_ready()
	$MusicBox.stop()
	$RestartButton/RestartSound.play()
	$TitleLabel.show()
	$InstructionsLabel.show()
	$StartButton.show()
	$LeaderboardButton.show()
	$StartButton/StartMusic.play()


func _on_BackButton_pressed():
	_ready()
	$RestartButton/RestartSound.play()
	$TitleLabel.show()
	$InstructionsLabel.show()
	$StartButton.show()
	$LeaderboardButton.show()
	$BackButton.hide()
	pass # Replace with function body.
