extends Area2D

@export var health: int = 3
@export var lifetime_particles: float = 0.6  # duración de la explosión

func disable_collision():
	$CollisionShape2D.disabled = true

func take_damage(damage: int):
	print("recibio daño")
	health -= damage
	if health <= 0:
		destroy()

func destroy():
	# Activar partículas de explosión
	$CPUParticles2D.emitting = true
	
	# Opcional: reproducir sonido si lo tienes
	if has_node("AudioStreamPlayer2D"):
		$AudioStreamPlayer2D.play()
	
	# Desactivar sprite y colisión para que parezca destruido
	$Sprite2D.visible = false
	call_deferred("disable_collision")
	
	# Esperar que termine la animación de partículas antes de eliminar el asteroide
	await get_tree().create_timer(lifetime_particles).timeout
	queue_free()
