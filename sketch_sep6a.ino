// LECTURA DE POTENCIOMETRO - SENSOR DE POS

void setup() {
  Serial.begin(9600);
  Serial.println("CLEARDATA"); //  Este comando borra solo los datos registrados
  Serial.println("CLEARSHEET"); // Este comando borra todos los datos de ActiveSheet
  Serial.println("LABEL,Fecha,Hora,Segundos,Voltaje (V),Angulo (°)"); // Asignacion de columnas para hoja de datos
  Serial.println("RESETTIMER");
}

void loop() {
  int sensorValue = analogRead(A0);
  // Se realiza la conversion de la lectura analógica (que va de 0 - 1023) a un voltaje (0 - 5V):
  float voltage = sensorValue * (5.0 / 1023.0);
  // Realizamos la conversión del voltaje al ángulo mecanico del pot 
  float angulo = (voltage / 5.0) * 300.0; // 5V corresponden a 300° y 0V a 0°
  
  Serial.print("DATA,DATE,TIME,TIMER,");
  Serial.print(voltage);
  Serial.print(",");
  Serial.println(angulo);
  delay(200);
}