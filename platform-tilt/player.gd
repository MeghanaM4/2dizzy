extends CharacterBody2D


const SPEED: float = 600.0
const JUMP_VELOCITY: float = -1000.0

var tilt_velocity: float = 0
const TILT_ACCELERATION: float = 120
const MAX_TILT_VELOCITY: float = 60

var serial: GdSerial
var buffer: String = ""


func _physics_process(delta: float) -> void:
	var tilt_dir: float = 1.0 if Input.is_action_pressed("tilt") else -1.0
	print(tilt_dir)
	tilt_velocity = move_toward(tilt_velocity, MAX_TILT_VELOCITY * tilt_dir, delta * TILT_ACCELERATION)
	
	rotation_degrees += tilt_velocity * delta
	up_direction = Vector2.from_angle(rotation - PI / 2.0)
	velocity = velocity.rotated(-rotation)
	if not is_on_floor():
		velocity += get_gravity() * delta * (4.0 if velocity.y > 0 else 2.5)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity = velocity.rotated(rotation)
	$ColorRect.rotation = up_direction.angle() - rotation
	move_and_slide()
