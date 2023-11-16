#include <Wire.h>
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2); 
const int ldrPin = A7;  
const float resistenciaLDR = 210.0;  // Valor LDR (ohms) 1Meg
const float anguloSolido = 2;  // Ángulo sólido en steradianes 12.57 para linternas de telefono.

void setup() {
  lcd.init();                      
  lcd.backlight();                
  Serial.begin(9600);
}

void loop() {
  int lecturaLDR = analogRead(ldrPin);  // Lectura de pin analogico de LDR
  float voltajeLDR = (float)lecturaLDR / 1023.0 * 5.0;  // Conversion a voltaje
  float resistenciaLuminosidad = (5.0 - voltajeLDR) * resistenciaLDR / voltajeLDR;  // Calculo para la resistencia segun X luminosidad

  // Conversion de Resistencia a Lumenes
  float lux = 500 / (resistenciaLuminosidad / 1000.0);
  // Calculo de intensidad luminosa (candelas)
  float candelas = lux / anguloSolido;

  lcd.clear();  
  lcd.setCursor(0, 0);
  lcd.print("FLu:");
  lcd.setCursor(5, 0);
  lcd.print(lux);
  lcd.print(" lux");

  lcd.setCursor(1, 1);
  lcd.print("ILum:");
  lcd.setCursor(7, 1);
  lcd.print(candelas);
  lcd.print(" cd");
  delay(1000);  
}