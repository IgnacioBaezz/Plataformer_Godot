extends CharacterBody2D

# Variables/Nodos en el inspector 
@export var input_prefix : String = "p1_"  # prefijo de inputs (ej: "p1_", "p2_")
@export var ship_texture: Texture2D     # sprite de la nave (seleccionable en inspector)
@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.3      # segundos entre disparos

# Nodos
@onready var thruster = $Thruster
@onready var sprite := $NaveTv01

# Variables
var thrust : float= -450.0         # fuerza del impulso
var damping : float = 0.99          # factor de desaceleración
var angular_velocity : float = 0.0
var angular_damping : float = 0.9   # resistencia al giro
var angular_accel : float = 0.4     # aceleración de rotación
var can_shoot : bool = true


func shoot():
	if not can_shoot:
		return
	can_shoot = false
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.rotation = rotation
	bullet.velocity = Vector2.UP.rotated(rotation) * bullet.speed
	get_tree().current_scene.add_child(bullet)
	
	# cooldown
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true

func _ready():
	# Asignar el sprite configurado en el inspector
	if ship_texture:
		sprite.texture = ship_texture


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
	
	if Input.is_action_pressed(input_prefix + "shoot") and can_shoot:
		shoot()
		
	# Aplicar "desgaste" a la velocidad
	velocity *= damping
	move_and_slide()
