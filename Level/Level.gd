extends Node2D

var areaArray #Array of all the screen edge areas. Used for in-play detection.
@export var basicBee:PackedScene #Scene for the basic bee. Used for instancing
@export var wasp:PackedScene #Scene for the Wasp hazard. Used for instancing.
@export var hazWarn:PackedScene #Scene for the telegraph that shows up before a wasp does.

@export var launchStrength:int #How hard the basic bee is thrown into the level.
@export var waspSpeed:int #How fast the Wasp hazard moves.

var currBees = 0 #The amount of bees on the screen at any given moment
var beeHigh = 0 #Player's high score. Persistent between runs.
#Change beeHigh to not set itself to 0 on game start. later.

signal deadBee #Emitted to all living bees in response to the beeDeath signal.

func _ready():
	areaArray = [$Areas/TopArea, $Areas/BottomArea, $Areas/LeftArea, $Areas/RightArea]
	

func _haz_spawn():
	var instance = hazWarn.instantiate()
	var aimAngle = randf_range(-PI/4, PI/4) #rotation applied to the wasp
	add_child(instance)
	
	$Path2D/PathFollow2D.progress = randi()
	
	#position the instance
	instance.global_position = $Path2D/PathFollow2D.global_position
	
	instance.rotation = ($LaunchPoint.global_position - instance.global_position).rotated(aimAngle).angle() + PI/2
	
	instance.connect("delayUp", on_delay_up)


func _bee_spawn():
	currBees += 1 #Score checker
	if currBees > beeHigh: beeHigh = currBees
	$CurrScore.text = str(currBees)
	$HighScore.text = str(beeHigh)
	
	var instance = basicBee.instantiate()
	add_child(instance)
	
	#Connect the signals to allow for death detection
	instance.beeDeath.connect(_on_bee_death)
	deadBee.connect(Callable(instance, "_dead_bee"))
	
	#Find a position along the edge
	$Path2D/PathFollow2D.progress = randi()
	
	#position the instance
	instance.global_position = $Path2D/PathFollow2D.global_position
	
	#Launch the instance inward
	instance.apply_central_impulse(($LaunchPoint.position - instance.position).normalized() * launchStrength)


func _body_on_screen(body):
	#Do nothing if any other area also intersects this body
	for i in areaArray:
		if i.overlaps_body(body):
			return
	
	body._enter_play() #The true ready() function. Every active body will need one.

func _on_bee_death(beePos):
	deadBee.emit(beePos)
	currBees -= 1
	$CurrScore.text = str(currBees)

func begin():
	$HazTimer.start()
	$BeeTimer.start()
	$AnimationPlayer.play("difficulty")

func on_delay_up(pos, rot):
	var instance = wasp.instantiate()
	add_child(instance)
	instance.global_position = pos
	instance.velocity = Vector2(0, 1).rotated(rot + PI) * waspSpeed
	instance.get_node("Sprite").rotation = instance.velocity.angle() + PI/2
