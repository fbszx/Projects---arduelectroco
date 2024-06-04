
// Codigo Carro Seguidor - MODO para seguimiento de Linea
// Edwin Fabian Cubides Pulido
// Kevin Johan Gonzales Cely
// Crsitian Andres Pinilla Sarmiento

#include <Arduino.h> // Importacion y Definicion de funciones basicás de plataforma arduino

#include <QTRSensors.h> // Importacion de Libreria para arreglo de sensores QTR8RC
QTRSensors qtr;         // Creacion de Instancia para objeto "qtr"
const uint8_t SensorCount = 8;  // Numero de sensores en el arreglo
uint16_t sensorValues[SensorCount]; // Arreglo para almacenar los valores de los sensores

// Constantes PID

float Kp = 0.005;  // Constante proporcional
float Ki = 0;      // Constante integral
float Kd = 0.0025; // Constante derivativa

// Varialbes para los terminos PID

int P;
int I;
int D;

int lastError = 0;       // Variable para alamacenamiento de ultimo error
boolean onoff = false;   // Variable de estado para encendido y apagado


// Velocidad base y maxima para Motores
const uint8_t maxspeeda = 32;
const uint8_t maxspeedb = 32;
const uint8_t basespeeda = 30;
const uint8_t basespeedb = 30;

// ============================================================
const int LED_CALIB = 17;   // Pin 17 para LED de indicacion de calibrado

const int PWA = 15;  // Pin 15 para señal PWM de motor A
const int PWB = 2;   // Pin 2 para señal PWM de motor B

const int AIN1 = 13; // Pin D13 para control dirección motor A
const int AIN2 = 12; // Pin D12 para control dirección motor A
const int BIN1 = 14; // Pin D14 para control dirección motor B
const int BIN2 = 27; // Pin D27 para control dirección motor B

const int buttoncalibrate = 26; // Pin 26 para calibraciòn
const int buttonstart = 25;  // Pin 25 para inicio

// Función para avanzar con freno controlado

void forward_brake(int posa, int posb) {
  
  digitalWrite(AIN1, HIGH);
  digitalWrite(AIN2, LOW);
  
  digitalWrite(BIN1, HIGH);
  digitalWrite(BIN2, LOW);

  analogWrite(PWA, posa);
  analogWrite(PWB, posb);
}

// Función de control PID

void PID_control() {
  uint16_t position = qtr.readLineBlack(sensorValues);
  int error = 3500 - position;

  for (uint8_t i = 0; i < SensorCount; i++)
  {
    Serial.print(sensorValues[i]);
    Serial.print('\t');
  }
  Serial.println(position);

  P = error;
  I = I + error;
  D = error - lastError;
  lastError = error;
  int motorspeed = P*Kp + I*Ki + D*Kd;
  
  int motorspeeda = basespeeda + motorspeed;
  int motorspeedb = basespeedb - motorspeed;
  
  if (motorspeeda > maxspeeda) {
    motorspeeda = maxspeeda;
  }
  
  if (motorspeeda < 0) {
    motorspeeda = 0;
  }
  if (motorspeedb < 0) {
    motorspeedb = 0;
  } 
  //Serial.print(motorspeeda);Serial.print(" ");Serial.println(motorspeedb);
  forward_brake(motorspeedb, motorspeeda);
}

// Función de calibración

void calibration() {
  digitalWrite(LED_CALIB, HIGH);
  for (uint16_t i = 0; i < 400; i++)
  {
    qtr.calibrate();
  }
  digitalWrite(LED_CALIB, LOW);
}

// Configuración inicial
void setup() {

 Serial.begin(9600);
 qtr.setTypeRC();
 qtr.setSensorPins((const uint8_t[]){5, 18, 19, 21, 22, 23, 32, 33}, SensorCount);
 qtr.setEmitterPin(4);

 pinMode(PWA, OUTPUT);
 pinMode(PWB, OUTPUT);

 pinMode(AIN1, OUTPUT);
 pinMode(AIN2, OUTPUT);
 pinMode(BIN1, OUTPUT);
 pinMode(BIN2, OUTPUT);

 pinMode(buttoncalibrate, INPUT);
 pinMode(buttonstart, INPUT);

 pinMode(LED_CALIB, OUTPUT);
 delay(500);
 
 boolean Ok = false;
  while (Ok == false) { //El loop no inicia hasta que se calibren los sensores
    if(digitalRead(buttoncalibrate) == HIGH) {
      calibration(); //Calibracion de sensores QTR por 10Segundos
      Ok = true;
    }
  }
  forward_brake(0, 0);
}

// Loop principal
void loop() {
  if(digitalRead(buttonstart) == HIGH) {
    onoff =! onoff;
    if(onoff = true) {
      delay(1000);    //Delay de inicio 
    }
    else {
      delay(50);
    }
  }
  if (onoff == true) {
    PID_control();   // Salto a funcion PID
  }
  else {
    forward_brake(0,0); // Salto a funcion para avance
  }
}

