extends RigidBody2D

@export var flapSeverity:int
@export var speed:int

func _ready():
	pass
	#Figure out how to get it into the stange with all the collision boxes there.

func _enter_play(): #When fully on the screen
	
	#Activate collision detection.
	collision_layer = 1
	collision_mask = 7 #Edit this if you add more collision masks

func _physics_process(_delta):
	#WHILE the mouse is pressed
	if Input.is_action_pressed("mouse_down"):
		#point and fire toward the mouse
		apply_central_impulse((get_global_mouse_position() - global_position).normalized() * speed)

func _timer_flap():
	apply_central_impulse(Vector2(1, 0).rotated(randf() * 2 * PI) * flapSeverity)
	#randomly adjust the flap timer interval to somewhere within a given window

#Idea: shockwave death.

#die() function: Broadcasts own position in signal 'death', then queue-frees, maybe with anim.
#witness_murder() function: called by 'death'. Pulses away from death site, scaled with proximity.

func _on_hit(body):
	#If you're hitting something dangerous
	if (body.is_in_group("hazard")):
		#broadcast own position
		
		#Change animation
		$Sprite.play("Explode")
		
		#I don't deactivate collision, as I'm not sure how to do it.
		
		#Stop moving for comedic effect, made complicated by query-flushing
		set_deferred('freeze', true)


func _on_anim_over(): #When the explosion is done
	queue_free()
