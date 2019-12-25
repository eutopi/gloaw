extends Node2D

export (PackedScene) var Ground
export (PackedScene) var Demon
export (PackedScene) var Collectable

const GROUND_LENGTH = 1000
const DEMON_TIMER_WAIT_TIME = 4
const COLLECTABLE_TIMER_WAIT_TIME = 1

var savegame = File.new()
var save_path = "user://savegame.save"
var save_data = {}

var screensize
var started = false
var ground_pos = Array()
var time_dis = 1
var score = 1
var demon_count = 0
var won = false
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if not savegame.file_exists(save_path):
		create_save()
	screensize = get_viewport_rect().size
	add_ground('LEFT')
	add_ground('RIGHT')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ground_pos[-1] > $Player.position.x + screensize.x / 2:
			add_ground('LEFT')
	elif ground_pos[0] < $Player.position.x - screensize.x / 2:
			add_ground('RIGHT')
	if started:
		time_dis /= 2
		$HUD.update_score(score)
		$HUD/TimerLabel.text = "Time: " + str(time)
		if score <= 0:
			end_game()
		if score >= 5:
			win_game()
	
func new_game():
	won = false
	score = 1
	time = 0
	demon_count = 0
	$Player/DemonRow.hide()
	$DemonTimer.set_wait_time(DEMON_TIMER_WAIT_TIME)
	$DemonTimer.start()
	$CollectableTimer.set_wait_time(COLLECTABLE_TIMER_WAIT_TIME)
	$CollectableTimer.start()
	$GameTimer.start()
	$HUD/BackgroundMusic.play()
	$HUD.update_score(score)
	started = true
	
func end_game():
	$HUD/GreyscaleShader.show()
	$HUD/GreyscaleShader/Static.play()
	$DemonTimer.stop()
	$CollectableTimer.stop()
	$GameTimer.stop()
	$HUD/BackgroundMusic.stop()
	$HUD/RestartButton.show()
	$HUD/HomeButton.show()
	$HUD/TimerLabel.hide()
	started = false
	
func win_game():
	won = true
	$DemonTimer.stop()
	$CollectableTimer.stop()
	$GameTimer.stop()
	$HUD/BackgroundMusic.stop()
	$WinTimer.start()
	started = false

func create_save():
	savegame.open(save_path, File.WRITE)
	savegame.store_var(save_data)
	savegame.close()
	
func save_game(score, datetime):
	save_data = load_game()
	save_data[score] = datetime
	savegame.open(save_path, File.WRITE)
	savegame.store_var(save_data)
	savegame.close()

func load_game():
	savegame.open(save_path, File.READ)
	save_data = savegame.get_var()
	savegame.close()
	return save_data

func add_ground(mode):
	var ground = Ground.instance()
	add_child(ground)
	if mode == 'LEFT':
		ground.position.x = $Player.position.x - GROUND_LENGTH
		ground_pos.append(ground.position.x)
	elif mode == 'RIGHT':
		ground.position.x = $Player.position.x + GROUND_LENGTH
		ground_pos.insert(0, ground.position.x) # add to beginning

func _on_DemonTimer_timeout():
	if started:
		var demon = Demon.instance()
		add_child(demon)
		if randi() % 2 == 0:
			demon.position.x = $Player.position.x + 400 + rand_range(0,100)
			demon._set_orientation(true)
		else:
			demon.position.x = $Player.position.x - rand_range(0,100)
			demon._set_orientation(false)
		demon.position.y += 35
		demon_count += 1

func _on_CollectableTimer_timeout():
	if started:
		var collectable = Collectable.instance()
		add_child(collectable)
		collectable.position.x = $Player.position.x + rand_range(-300,300)
		collectable.position.y = $Player.position.y - 400

func increase_score():
	if started:
		$Beep1.play()
		score += 2

func decrease_score():
	if started:
		$Beep2.play()
		score -= 1

func decrease_demon_count():
	if !won:
		$DemonSound.play()
		demon_count -= 1

func _on_WinTimer_timeout():
	$HUD/ScoreLabel.hide()
	$HUD/MusicBox.play()
	$HUD/Applause.play()
	$HUD/RestartButton.show()
	$HUD/HomeButton.show()
	$Player/DemonRow.show()
	$HUD/TimerLabel.hide()
	$HUD/WinningScoreLabel.text = str(time)
	$HUD/WinningScoreLabel.show()
	var datetime = OS.get_datetime()
	var currdate = format_time(datetime.get('month'))+'/'+format_time(datetime.get('day'))+'/'+str(datetime.get('year'))
	var currtime = format_time(datetime.get('hour'))+':'+format_time(datetime.get('minute'))+':'+format_time(datetime.get('second'))
	save_game(time, currdate + ' ' + currtime)

func format_time(t):
	if t % 10 == t:
		return str('0' + str(t))
	else:
		return str(t)

func _on_GameTimer_timeout():
	time += 0.1
