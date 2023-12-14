extends Node2D

signal delayUp


func _ready():
	var animArray = [$animStack/Sprite1, $animStack/Sprite2, $animStack/Sprite3, $animStack/Sprite4, $animStack/Sprite5, $animStack/Sprite6, $animStack/Sprite7, $animStack/Sprite8]
	for i in animArray: #Set all the sprite nodes going
		i.play("default")

func _on_delay_up(): #The animation is finished
	emit_signal("delayUp", global_position, rotation) #Spawn the wasp
	queue_free()
