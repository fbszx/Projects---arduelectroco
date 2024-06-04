
// Codigo Carro Seguidor - Operacion Manual
// Edwin Fabian Cubides Pulido
// Kevin Johan Gonzales Cely
// Crsitian Andres Pinilla Sarmiento


#include <Arduino.h> // Importacion y Definicion de funciones basicás de plataforma arduino

#include "BluetoothSerial.h"  // Importacion de Libreria para uso de periferico Bluetooth
BluetoothSerial SerialBT;     // Creacion de objeto para bluetooth  "SerialBT"


// Declaracion de variables y pines para los pines de sensor ultrasonico

const int TrigPin = 3; //pin 3 para trig 
const int EchoPin = 1; //pin 4 para echo


// Declaracion de variables y pines para los motores (Puente H)

const int MotorL1 = 13; // Pin D13 para control dirección motor A
const int MotorL2 = 12; // Pin D12 para control dirección motor A
const int MotorR1 = 14; // Pin D24 para control dirección motor B
const int MotorR2 = 27; // Pin D27 para control dirección motor B

const int ENABLEL = 15; // Pin D24 para control de velocidad motor A
const int ENABLER = 2; // Pin D27 para control de velocidad  motor B

int velocidad = 50;   // Velocidad en pines analogicos para enables PWMs
int minDistance = 2;  // Variables para medicion de ditancia en sensor ultrasonico
int maxDistance = 10;
int distance;


int calculateDistance() {
  
  int duration, dist; 
//Se emiten pulsos a traves del ultrasonico activando y desactivando  su transmisión 
  digitalWrite(TrigPin, HIGH);       //inicia la transmision de pulso 
  delay(1);
  digitalWrite(TrigPin, LOW);        //detienen la transmision de pulso
  
  duration = pulseIn(EchoPin, HIGH); //Se mide la duración de un pulso de alto nivel en el pin y lo almacena en duration 
  dist = duration / 58.2;            //calcula la distancia en centímetros a partir de la duración del pulso y lo almacena en dist
  delay(10);
  return dist;
}


void setup() {
  
  //Incicalizamos el nombre del bluetooth para conectar al telefono e inicializamos la velocidad de transmision a 115200 baudios 
  
  SerialBT.begin("Carro Seguidor de Linea");
  Serial.begin(115200);

 //definimos los pines como entrada/salida
  pinMode(EchoPin, INPUT); 
  pinMode(TrigPin, OUTPUT); 

  pinMode(MotorL1, OUTPUT);
  pinMode(MotorL2, OUTPUT);

  pinMode(MotorR1, OUTPUT);
  pinMode(MotorR2, OUTPUT);

  pinMode(ENABLEL, OUTPUT);
  pinMode(ENABLER, OUTPUT);

}

void loop() {

  
  distance = calculateDistance();  // Funcion para calculo de distancia

  analogWrite(ENABLEL, velocidad);
  analogWrite(ENABLER, velocidad);

  if (SerialBT.available()) {     // Verificacion de conexion Bluetooth con ESP32
    char c = SerialBT.read();
    Serial.println(c);
  

   //Dependiendo del caracter leido por el serial, se tomaran acciones en los motores (Adelante, Atras, Izquierda, Derecha o Stop)

  if (c=='A'){
      digitalWrite(MotorL1, HIGH);
      digitalWrite(MotorL2, LOW);
      digitalWrite(MotorR1, HIGH);
      digitalWrite(MotorR2, LOW);
      delay(300);
      digitalWrite(MotorL1, LOW);
      digitalWrite(MotorL2, LOW);
      digitalWrite(MotorR1, LOW);
      digitalWrite(MotorR2, LOW);
    }
  
  if (c=='B'){
      digitalWrite(MotorL1, LOW);
      digitalWrite(MotorL2, HIGH);
      digitalWrite(MotorR1, LOW);
      digitalWrite(MotorR2, HIGH);
      delay(300);
      digitalWrite(MotorL1, LOW);
      digitalWrite(MotorL2, LOW);
      digitalWrite(MotorR1, LOW);
      digitalWrite(MotorR2, LOW);
    }
  
  if (c=='I'){
      digitalWrite(MotorL1, LOW);
      digitalWrite(MotorL2, LOW);
      digitalWrite(MotorR1, LOW);
      digitalWrite(MotorR2, HIGH);
      delay(50);
      digitalWrite(MotorL1, LOW);
      digitalWrite(MotorL2, LOW);
      digitalWrite(MotorR1, LOW);
      digitalWrite(MotorR2, LOW);
    }
  
  if (c=='D'){
      digitalWrite(MotorL1, LOW);
      digitalWrite(MotorL2, HIGH);
      digitalWrite(MotorR1, LOW);
      digitalWrite(MotorR2, LOW);
      delay(50);
      digitalWrite(MotorL1, LOW);
      digitalWrite(MotorL2, LOW);
      digitalWrite(MotorR1, LOW);
      digitalWrite(MotorR2, LOW);
    }
  
  if (c=='S'){
      
      digitalWrite(MotorL1, LOW);
      digitalWrite(MotorL2, LOW);
      digitalWrite(MotorR1, LOW);
      digitalWrite(MotorR2, LOW);
    }
  
  if (c=='O'){
      digitalWrite(MotorL1, LOW);
      digitalWrite(MotorL2, LOW);
      digitalWrite(MotorR1, LOW);
      digitalWrite(MotorR2, LOW);
    }
}
}
