extends StaticBody2D

var velocity:Vector2 #set by other scripts

func _physics_process(delta):
	move_and_collide(velocity)

func _offscreen(): #Signal from VisibilityDetector node
	queue_free()
