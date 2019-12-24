extends Node2D

export (PackedScene) var Ground
export (PackedScene) var Demon
export (PackedScene) var Collectable

const GROUND_LENGTH = 1000
const DEMON_TIMER_WAIT_TIME = 4
const COLLECTABLE_TIMER_WAIT_TIME = 1

var screensize
var started = false
var ground_pos = Array()
var time_dis = 1
var score = 1
var demon_count = 0


# Called when the node enters the scene tree for the first time.
func _ready():
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
		if score <= 0:
			end_game()
	
	
func new_game():
	score = 1
	demon_count = 0
	$DemonTimer.set_wait_time(DEMON_TIMER_WAIT_TIME)
	$DemonTimer.start()
	$CollectableTimer.set_wait_time(COLLECTABLE_TIMER_WAIT_TIME)
	$CollectableTimer.start()
	$HUD/BackgroundMusic.play()
	$HUD.update_score(score)
	started = true

func end_game():
	$HUD/GreyscaleShader.show()
	$HUD/GreyscaleShader/Static.play()
	$DemonTimer.stop()
	$CollectableTimer.stop()
	$HUD/BackgroundMusic.stop()
	$HUD/RestartButton.show()
	$HUD/HomeButton.show()
	started = false

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
	$DemonSound.play()
	demon_count -= 1