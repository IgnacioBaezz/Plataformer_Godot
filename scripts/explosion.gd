extends Area2D

@export var explosion_scene: PackedScene

func destroy():
	# Instanciar explosión
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	
	# Destruir asteroide
	queue_free()
