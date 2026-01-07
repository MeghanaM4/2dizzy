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
  Serial.println(digitalRead(TILTPIN));
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

  if(distance < 5) {
    Serial.println("JUMP");
    delay(100);
  }

  delay(20);
}
