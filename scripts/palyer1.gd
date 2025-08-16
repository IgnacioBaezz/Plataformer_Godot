extends CharacterBody2D  # Usa KinematicBody2D si estás en Godot 3.x

# Velocidad base de la nave
var speed := 300.0

# Límite de movimiento dentro de la pantalla
var screen_bounds := Rect2(Vector2.ZERO, Vector2.ZERO)

func _ready():
	# Obtener el tamaño de la pantalla
	screen_bounds.size = get_viewport_rect().size

func _process(delta):
	var direction := Vector2.ZERO

	# Movimiento con teclas
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	# Normalizar para evitar velocidad diagonal excesiva
	direction = direction.normalized()

	# Mover la nave
	velocity = direction * speed
	move_and_slide()

	# Limitar posición dentro de la pantalla
	position.x = clamp(position.x, 0, screen_bounds.size.x)
	position.y = clamp(position.y, 0, screen_bounds.size.y)
