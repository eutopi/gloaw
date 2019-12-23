extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	$ScoreLabel.hide()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_StartButton_pressed():
	$StartButton.hide()
	$TitleLabel.hide()
	$InstructionsLabel.hide()
	$ScoreLabel.show()
	emit_signal("start_game")
