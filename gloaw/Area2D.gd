extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var motion = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !get_parent().started or Input.is_action_pressed("ui_restart"):
		queue_free()

func _physics_process(delta):
	motion.y += 3 * delta
	translate(motion)

func _on_Collectable_body_entered(body):
	if body.get_name() == "Player":
		if get_parent().demon_count == 0:
			get_parent().increase_score()
		else:
			get_parent().decrease_score()
	else:
		get_parent().score -= 1
	queue_free()
	pass # Replace with function body.
