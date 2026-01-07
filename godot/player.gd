extends CharacterBody2D


const SPEED: float = 600.0
const JUMP_VELOCITY: float = -1000.0

var tilt_dir: float = 0.0
var tilt_velocity: float = 0.0
const TILT_ACCELERATION: float = 120.0
const MAX_TILT_VELOCITY: float = 60.0

var serial: GdSerial
var buffer: String = ""

var jump_time: float = 0
var joystick: float = 0

@export var list_ports_parent: VBoxContainer
@export var panel: Panel
@export var no_gamepad_btn: Button
signal port_selected(port: String)


func _ready() -> void:
	serial = GdSerial.new()
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	
	no_gamepad_btn.pressed.connect(func() -> void: port_selected.emit("none"))
	var ports: Dictionary = serial.list_ports()
	for port in ports.values():
		if "port_name" in port:
			var btn: Button = Button.new()
			btn.text = port["port_name"]
			btn.pressed.connect(func() -> void:
				port_selected.emit(port["port_name"])
				print(port["port_name"])
			)
			list_ports_parent.add_child(btn)
	var port: String = await port_selected
	panel.visible = false
	get_tree().paused = false
	process_mode = Node.PROCESS_MODE_INHERIT
	if port != "none":
		serial.set_port(port)
		serial.set_baud_rate(115200)
		serial.open()


func read_line(handle_line: Callable) -> void:
	if serial.is_open():
		var bytes_available = serial.bytes_available()
		if bytes_available > 0:
			var data = serial.read(bytes_available)
			buffer += data.get_string_from_utf8()
			while "\n" in buffer:
				var line_end = buffer.find("\n")
				var line = buffer.substr(0, line_end - 1)
				buffer = buffer.substr(line_end + 1)
				handle_line.call(line)

func _exit_tree():
	if serial and serial.is_open():
		serial.close()


func _physics_process(delta: float) -> void:
	jump_time -= delta
	if serial.is_open():
		read_line(func(line: String) -> void:
			var data: Variant = JSON.parse_string(line)
			print(data)
			if data is Dictionary:
				tilt_dir = 1.0 if data.get("tilt", 0.0) else -1.0
				if data.get("jump", 0) == 1.0:
					jump_time = 0
				joystick = data.get("joystick", 0.0)
		)
	else:
		tilt_dir = 1.0 if Input.is_action_pressed("tilt") else -1.0
	tilt_velocity = move_toward(tilt_velocity, MAX_TILT_VELOCITY * tilt_dir, delta * TILT_ACCELERATION)
	
	rotation_degrees += tilt_velocity * delta
	up_direction = Vector2.from_angle(rotation - PI / 2.0)
	velocity = velocity.rotated(-rotation)
	if not is_on_floor():
		velocity += get_gravity() * delta * (4.0 if velocity.y > 0 else 2.5)
	if (Input.is_action_just_pressed("jump") or jump_time >= 0.0) and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if serial.is_open():
		if joystick:
			velocity.x = joystick * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		var direction: float = Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity = velocity.rotated(rotation)
	$ColorRect.rotation = up_direction.angle() - rotation
	move_and_slide()
