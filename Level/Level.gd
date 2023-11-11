extends Node2D


func _ready():
	pass # Replace with function body.


func _process(delta):
	pass

func _haz_spawn():
	pass
	#Spawn a dude. Use a switch-case, or dont, but spawn something.
	
	# Use the Path2D and the PathFollow2D to position it
	# Set its velocity vector to the center of the screen
	# Connect any signals.


func _bee_spawn():
	pass
	#Spawn a bee.
	
	#Use the Path2D to position it
	#Launch it towards the center using apply_central_impulse.
	
	
	
	#Called as a signal from 1 of 4 area nodes with the same physics shapes as the walls.
	#Signal is broadcasted on_body_exited
	#Changes the collision layer of the body passed as an argument such that it now collides with walls.


func _body_in_play(body_rid, body, body_shape_index, local_shape_index):
	pass # Replace with function body.
