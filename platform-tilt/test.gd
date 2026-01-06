extends Node


var udp_server = PacketPeerUDP.new()
var port = 5005


func _ready():
	udp_server.bind(port)
	print("Listening for tilt data on port ", port)

func _process(delta):
	if udp_server.get_available_packet_count() > 0:
		var packet = udp_server.get_packet()
		var data_string = packet.get_string_from_utf8()

		var json = JSON.new()
		var parse_result = json.parse(data_string)

		if parse_result == OK:
			var data = json.data
			var tilt_angle = data.x * 15.0
			print(data)
