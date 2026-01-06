import serial
import socket
import json
import time

SERIAL_PORT = 'COM13'
BAUD_RATE = 115200

UDP_IP = "localhost"
UDP_PORT = 5005
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

print("connecting to arduino")

try:
    arduino = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)
    time.sleep(2)
    print(f"Connected to Arduino on {SERIAL_PORT}")
    print(f"Sending data to {UDP_IP}:{UDP_PORT}")
    
    
    while True:
        if arduino.in_waiting > 0:
            #read sensor
            line = arduino.readline().decode('utf-8').strip()
            
            try:
                sensor_state = int(line)
                
                #send UDP packet
                data = {
                    'x': sensor_state,
                    'y': 0.0
                }
                message = json.dumps(data).encode()
                sock.sendto(message, (UDP_IP, UDP_PORT))
                
                print(sensor_state)
                
            except ValueError:
                pass
                
except serial.SerialException as e:
    print(f"\nError: Could not open serial port {SERIAL_PORT}")
    print("Make sure:")
    print("1. Arduino is connected via USB")
    print("2. Correct port is specified")
    print("3. No other program is using the port")
    print(f"\nError details: {e}")
    
except KeyboardInterrupt:
    print("\n\nStopped")
    
finally:
    if 'arduino' in locals():
        arduino.close()
    sock.close()