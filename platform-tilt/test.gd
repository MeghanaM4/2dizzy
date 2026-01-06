extends Node

var serial: GdSerial
var buffer: String = ""

func _ready():
	serial = GdSerial.new()
	
	var ports: Dictionary = serial.list_ports()
	print("Available ports: ", ports)
	
	serial.set_port("/dev/ttyACM0")
	serial.set_baud_rate(115200)
	if serial.open():
		print("Connected!")

func _process(_delta):
	if serial.is_open():
		var bytes_available = serial.bytes_available()
		if bytes_available > 0:
			var data = serial.read(bytes_available)
			buffer += data.get_string_from_utf8()
			
			while "\n" in buffer:
				var line_end = buffer.find("\n")
				var line = buffer.substr(0, line_end)
				buffer = buffer.substr(line_end + 1)
				
				print("Received line: ", line)

func _exit_tree():
	if serial and serial.is_open():
		serial.close()
