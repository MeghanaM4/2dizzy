int TILTPIN = 7;

void setup() {
  Serial.begin(115200);
  pinMode(TILTPIN, INPUT);

}

void loop() {
  Serial.println(digitalRead(TILTPIN));
  delay(20);

}
