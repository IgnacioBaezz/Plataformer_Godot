extends CharacterBody2D

var thrust := -450.0        # fuerza del impulso al presionar "ui_up"
var damping := 0.99           # factor de desaceleración (0.99 = pierde 1% por frame aprox.)
var angular_velocity := 0.0
var angular_damping := 0.9    # cuánto se reduce la velocidad de giro (entre 0 y 1)
var angular_accel := 0.3      # aceleración de rotación al pulsar tecla
@onready var thruster := $Thruster

func _physics_process(delta):
	# Aceleración de rotación
	if Input.is_action_pressed("izquierda"):
		angular_velocity -= angular_accel * delta
	if Input.is_action_pressed("derecha"):
		angular_velocity += angular_accel * delta

	# Aplicar damping a la rotación (simula resistencia)
	angular_velocity *= angular_damping

	# Aplicar la rotación acumulada
	rotation += angular_velocity

	# Impulso hacia adelante
	if Input.is_action_pressed("impulso"):
		var direction = Vector2.DOWN.rotated(rotation) # Vector hacia donde apunta la nave
		velocity += direction * thrust * delta
		# Activar partículas
		if not thruster.emitting:
			thruster.emitting = true
	else:
		# Desactivar partículas cuando no haya impulso
		if thruster.emitting:
			thruster.emitting = false
	# Aplicar "desgaste" a la velocidad (simula rozamiento leve)
	velocity *= damping
	move_and_slide()
