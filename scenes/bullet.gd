extends Area2D

@export var speed: float = 600.0      # Velocidad de la bala
@export var lifetime: float = 2.0     # Tiempo máximo en segundos antes de desaparecer
@export var damage: int = 1           # Daño que causa la bala

var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Destruir la bala después de un tiempo para evitar acumular objetos
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta: float) -> void:
	position += velocity * delta
	


func _on_area_entered(area: Area2D) -> void:
	print("area detectada")
	if area.is_in_group("asteroides"):
		area.destroy()
		queue_free()  # destruir la bala
		return
	if area.has_method("take_damage"):
		area.take_damage(damage)
	queue_free()

func _on_body_entered(body: Node) -> void:
	print("colision detectada")
	if body.is_in_group("asteroides"):
		body.take_damage(1)
	queue_free()
