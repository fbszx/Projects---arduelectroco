#include <Wire.h>
#include "Adafruit_TCS34725.h"
#include <LiquidCrystal_I2C.h>
#include <Stepper.h> //Importamos la librería para controlar motores paso a paso
int pinin=7;
int motor=4;
int estado=0;
// Ponemos nombre al motor, el número de pasos y los pins de control
Stepper MotorPasos1(200, 8, 9, 10, 11); 


LiquidCrystal_I2C lcd(0x27, 16, 2);

#define redpin 3
#define greenpin 5
#define bluepin 6

#define commonAnode true

byte gammatable[256];

Adafruit_TCS34725 tcs = Adafruit_TCS34725(TCS34725_INTEGRATIONTIME_50MS, TCS34725_GAIN_4X);

void setup() {
  Serial.begin(9600);
  MotorPasos1.setSpeed(20);
  pinMode(pinin, INPUT);
  pinMode(motor, OUTPUT);
  digitalWrite(motor, LOW); 

  lcd.init();
  lcd.backlight();
  if (tcs.begin()) {
    
  } else {
    Serial.println("No TCS34725 found ... check your connections");
    while (1); 
  }

  pinMode(redpin, OUTPUT);
  pinMode(greenpin, OUTPUT);
  pinMode(bluepin, OUTPUT);

  for (int i = 0; i < 256; i++) {
    float x = i;
    x /= 255;
    x = pow(x, 2.5);
    x *= 255;

    if (commonAnode) {
      gammatable[i] = 255 - x;
    } else {
      gammatable[i] = x;
    }
  }
}

void loop() {
  float red, green, blue;
  
  tcs.setInterrupt(false);
  delay(60);
  tcs.getRGB(&red, &green, &blue);
  tcs.setInterrupt(true);

  Serial.print("R:\t"); Serial.print(int(red)); 
  Serial.print("\tG:\t"); Serial.print(int(green)); 
  Serial.print("\tB:\t"); Serial.print(int(blue));
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("LA PINTURA ES ");
  lcd.setCursor(0, 1);
  lcd.print("COLOR:");

  if (detectarColor(red, green, blue, 110, 86, 41, 3, "Amarillo")) {  
    lcd.print("Amarillo");
  } else if (detectarColor(red, green, blue, 65, 81, 92, 3, "Azul")) {  
    lcd.print("Azul");
  } else if (detectarColor(red, green, blue, 78, 102, 70, 3, "Verde Claro")) {  
   lcd.print("Verde Claro");
  } else if (detectarColor(red, green, blue, 76, 89, 70, 3, "Verde Oscuro")) {  
    lcd.print("Verde Oscuro");
  } else if (detectarColor(red, green, blue, 92, 75, 63, 3, "Morado Claro")) {  
    lcd.print("Morado Claro");
  } else if (detectarColor(red, green, blue, 85, 90, 79, 3, "Morado Oscuro")) {  
    lcd.print("Morado Oscuro");
  } else if (detectarColor(red, green, blue, 82, 90, 67, 3, "Negro")) {  
    lcd.print("Negro");
  } else if (detectarColor(red, green, blue, 83, 83, 69, 3, "Gris Claro")) {  
    lcd.print("Gris Claro");
  } else if (detectarColor(red, green, blue, 80, 87, 62, 3, "Gris Oscuro")) {  
    lcd.print("Gris Oscuro");
  } else if (detectarColor(red, green, blue, 84, 60, 52, 3, "Rojo")) {  
    lcd.print("Rojo");
  } else if (detectarColor(red, green, blue, 126, 65, 60, 3, "Rosado")) {  
    lcd.print("Rosado");
  } else if (detectarColor(red, green, blue, 69, 88, 78, 3, "Turquesa")) {  
    lcd.print("Turquesa");
  } else if (detectarColor(red, green, blue, 135, 61, 49, 3, "Naranja Claro")) {  
    lcd.print("Naranja Claro");
  } else if (detectarColor(red, green, blue, 134, 61, 50, 3, "Naranja Oscuro")) {  
    lcd.print("Naranja Oscuro");
  } else if (detectarColor(red, green, blue, 95, 81, 59, 3, "NO-COLOR")) {  
    lcd.print("NO-COLOR"); 
  } else if (detectarColor(red, green, blue, 85, 85, 66, 3, "Azul")) {  
    lcd.print("Cafe");    
  } else if (detectarColor(red, green, blue, 79, 85, 76, 3, "Blanco")) {  
    lcd.print("Blanco");     
  } else {
    lcd.print("Desconocido");
  }

  Serial.print("\n");

  analogWrite(redpin, gammatable[(int)red]);
  analogWrite(greenpin, gammatable[(int)green]);
  analogWrite(bluepin, gammatable[(int)blue]);
  
  estado=digitalRead(pinin);
  Serial.println(estado);
  if (estado==HIGH)
  {
    MotorPasos1.step(55);
    delay(1000);
    digitalWrite(motor, HIGH);
    delay(10000);
    digitalWrite(motor, LOW);
    MotorPasos1.step(-61);
    delay(3000);
  }
  else {
}
}

bool detectarColor(float r, float g, float b, int pr, int pg, int pb, int tolerancia, const char* nombreColor) {
  if (abs(int(r) - pr) <= tolerancia && 
      abs(int(g) - pg) <= tolerancia && 
      abs(int(b) - pb) <= tolerancia) {
    return true;
  }
  return false;
}