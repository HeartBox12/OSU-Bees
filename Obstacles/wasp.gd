extends StaticBody2D

var velocity:Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_collide(velocity)


func _offscreen():
	queue_free()