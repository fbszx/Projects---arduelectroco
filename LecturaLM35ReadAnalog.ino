
// LECTURA SENSOR LM35

void setup() {
  
  Serial.begin(9600);
  Serial.println("CLEARDATA"); // Limpia datos -- Este comando borra solo los datos registrados
  Serial.println("CLEARSHEET"); //Limpia hoja -- Este comando borra todos los datos de ActiveSheet 
  Serial.println("LABEL,Fecha,Hora,Segundos,Voltaje (V) ,Centigrados *C");
  Serial.println("RESETTIMER");
}

void loop() {
  // Lectura de entrada analoga A0 
  int sensorValue = analogRead(A0);
  //Conversion del voltaje de entrada
  float voltage = sensorValue * (5.0 / 1023.0);
  float centigrados = voltage * 100;

  // Impresion de Valores Leidos
  //Serial.println( " Voltage : " + String(voltage) + "  --  Centigrados : " + String(centigrados));
  Serial.print("DATA,DATE,TIME,TIMER,"); 
  //Serial.print("Voltaje:");
  Serial.print(voltage);
  Serial.print(",");
  //Serial.print("Centigrados:");
  Serial.print(centigrados);
  Serial.println(); 
  delay(2000);
}
