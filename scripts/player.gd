extends CharacterBody2D

@export var input_prefix : String = "p1_"  # prefijo de inputs (ej: "p1_", "p2_")
var thrust : float= -450.0         # fuerza del impulso
var damping : float = 0.99          # factor de desaceleración
var angular_velocity : float = 0.0
var angular_damping : float = 0.9   # resistencia al giro
var angular_accel : float = 0.4     # aceleración de rotación
@onready var thruster = $Thruster

func _physics_process(delta):
	# Aceleración de rotación
	if Input.is_action_pressed(input_prefix + "izquierda"):
		angular_velocity -= angular_accel * delta
	elif Input.is_action_pressed(input_prefix + "derecha"):
		angular_velocity += angular_accel * delta

	# Aplicar damping a la rotación
	angular_velocity *= angular_damping

	# Aplicar la rotación acumulada
	rotation += angular_velocity

	# Impulso hacia adelante
	if Input.is_action_pressed(input_prefix + "impulso"):
		var direction = Vector2.DOWN.rotated(rotation)
		velocity += direction * thrust * delta
		# Activar partículas
		if not thruster.emitting:
			thruster.emitting = true
	else:
		# Desactivar partículas cuando no haya impulso
		if thruster.emitting:
			thruster.emitting = false

	# Aplicar "desgaste" a la velocidad
	velocity *= damping
	move_and_slide()
