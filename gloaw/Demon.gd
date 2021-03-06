extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !get_parent().started or Input.is_action_pressed("ui_restart"):
		queue_free()

func _on_demon_touched(body):
	if body.get_name() == "Player":
		get_parent().decrease_demon_count()
		queue_free()

func _set_orientation(b):
	$Sprite.flip_h = b