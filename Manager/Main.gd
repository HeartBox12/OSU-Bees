extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if Input.is_action_just_pressed("ui_accept"): begin()

func begin():
	$Anims.play("Begin")