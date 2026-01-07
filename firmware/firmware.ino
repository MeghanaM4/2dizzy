#define joystick_x A0

int TILTPIN = 7;
int TRIG = 4;
int ECHO = 3;

float duration, distance;

void setup() {
  pinMode(TILTPIN, INPUT);

  pinMode(TRIG, OUTPUT);
  pinMode(ECHO, INPUT);

  Serial.begin(115200);
}

void loop() {
  //Serial.print("Tilt: ")
  //Serial.println(digitalRead(TILTPIN));

  // if(digitalRead(TILTPIN)) {
  //   Serial.println("TILTED");
  // } else {
  //   Serial.println("FLAT");
  // }

  digitalWrite(TRIG, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG, LOW);

  duration = pulseIn(ECHO, HIGH);
  distance = (duration * 0.0343) / 2;
  //Serial.println(distance);

  float joystick_map = map(analogRead(joystick_x), 0, 1023, -1000, 1000);

  Serial.print("{\"tilt\": ");
  Serial.print(digitalRead(TILTPIN));
  Serial.print(", \"jump\": ");
  Serial.print(distance < 5);
  Serial.print(", \"joystick\": ");
  Serial.print(joystick_map/1000);
  Serial.println("}");


  delay(20);
}