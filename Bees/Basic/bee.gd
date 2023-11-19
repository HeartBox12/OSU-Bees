extends RigidBody2D

@export var flapSeverity:int #How hard the bee flaps
@export var speed:int #How fast the bee moves TOWARD THE CURSOR

@export var deathShock:int #How hard the bee recoils from dead bees
@export var shockThresh:int #How close the bee muse bee to bee shocked

var flapping = false #Flag for use when applying the flap. Used for setting sprite rotation
var pulse:Vector2 = Vector2(0, 0) #The pulse applied at the end of a frame

signal beeDeath

func _ready():
	pass
	#Connect the explosive death signal here.

func _enter_play(): #When fully on the screen
	#Activate collision detection.
	collision_layer = 1
	collision_mask = 7 #Edit this if you add more collision masks

func _physics_process(_delta):
	pulse = Vector2(0, 0)
	
	#WHILE the mouse is pressed
	if Input.is_action_pressed("mouse_down"):
		#point and fire toward the mouse
		pulse = (get_global_mouse_position() - global_position).normalized() * speed
		
	if flapping:
		pulse += Vector2(1, 0).rotated(randf() * 2 * PI) * flapSeverity
		flapping = false
	if (pulse.length() > 1):
		$Sprite.rotation = pulse.angle() + PI/2
	apply_central_impulse(pulse)

func _timer_flap():
	flapping = true
	#randomly adjust the flap timer interval to somewhere within a given window
	$Timer.wait_time = randf_range(0.75, 1.25)

#Idea: shockwave death.

#die() function: Broadcasts own position in signal 'death', then queue-frees, maybe with anim.
#witness_murder() function: called by 'death'. Pulses away from death site, scaled with proximity.

func _on_hit(body): #If you're hitting something dangerous. #Also called if it exits the screen
	if (!body || body.is_in_group("hazard")): #If body is null (for offscreening) or if it'd kill
		die()

func die():
	$Sprite.play("Explode")
		
	#Let the level script know
	beeDeath.emit(position)
		
	#I don't deactivate collision, as I'm not sure how to do it.
		
	#Stop moving and disable collision for comedic effect, made complicated by query-flushing
	set_deferred('freeze', true)
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)

func _on_anim_over(): #When the explosion is done
	queue_free()

func _dead_bee(pos): #When another bee dies
	var fromCorpse = position - pos
	
	if fromCorpse.length() < shockThresh:
		apply_central_impulse(fromCorpse.normalized() * deathShock / fromCorpse.length())
