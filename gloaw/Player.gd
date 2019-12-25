extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const SPEED = 200
const JUMP_HEIGHT = -500
var screen_size
var motion = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	position.y = 0
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	motion.y += GRAVITY
	
	if Input.is_action_pressed("ui_right"):
		motion.x = SPEED
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.play()
		$DemonRow.animation = "walk"
		$DemonRow.play()
	elif Input.is_action_pressed("ui_left"):
		motion.x = -SPEED
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.play()
		$DemonRow.animation = "walk"
		$DemonRow.play()
	else:
		motion.x = 0
		$AnimatedSprite.stop()
		$AnimatedSprite.animation = "default"
		$DemonRow.animation = "default"
		$DemonRow.stop()
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
	if Input.is_action_pressed("ui_accept"): #accelerate
		if Input.is_action_pressed("ui_right"):
			motion.x += 200
		elif Input.is_action_pressed("ui_left"):
			motion.x -= 200
	move_and_slide(motion, UP)