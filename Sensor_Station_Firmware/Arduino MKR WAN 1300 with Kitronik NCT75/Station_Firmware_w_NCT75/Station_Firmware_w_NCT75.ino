/*
  Lora Send And Receive
  This sketch demonstrates how to send and receive data with the MKR WAN 1300/1310 LoRa module.
  This example code is in the public domain.
*/

#include <MKRWAN.h>

LoRaModem modem;

// Uncomment if using the Murata chip as a module
// LoRaModem modem(Serial1);

#include "arduino_secrets.h"
// Please enter your sensitive data in the Secret tab or arduino_secrets.h
String appEui = SECRET_APP_EUI;
String appKey = SECRET_APP_KEY;

#include <Wire.h> //we include the Wire library as it deals with I2C communication
int tempsensorAddress = 0x48; //here we tell the Arduino where the sensor can be found on the I2C bus

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Wire.begin();
  while (!Serial);
  // change this to your regional band (eg. US915, AS923, ...)
  if (!modem.begin(EU868)) {
    Serial.println("Failed to start module");
    while (1) {}
  };
  Serial.print("Your module version is: ");
  Serial.println(modem.version());
  Serial.print("Your device EUI is: ");
  Serial.println(modem.deviceEUI());

  int connected = modem.joinOTAA(appEui, appKey);
  if (!connected) {
    Serial.println("Something went wrong; are you indoor? Move near a window and retry");
    while (1) {}
  }

  // Set poll interval to 60 secs.
  modem.minPollInterval(60);
  // NOTE: independently by this setting the modem will
  // not allow to send more than one message every 2 minutes,
  // this is enforced by firmware and can not be changed.
}

void loop() {
  
  //Serial.println();
  //Serial.println("Enter a message to send to network");
  //Serial.println("(make sure that end-of-line 'NL' is enabled)");

  
  
  //while (!Serial.available());
  //String msg = Serial.readStringUntil('\n');
  
  float celsius = getTemperature();
  String temp = String(celsius, 2);  
  
  /*
  Serial.println();
  Serial.print("Sending: " + temp + " - ");
  for (unsigned int i = 0; i < msg.length(); i++) {
    Serial.print(msg[i] >> 4, HEX);
    Serial.print(msg[i] & 0xF, HEX);
    Serial.print(" ");
  }
  Serial.println();
  */

  int err;
  modem.beginPacket();
  modem.print(temp);
  err = modem.endPacket(true);
  if (err > 0) {
    Serial.println("Message sent correctly!");
    Serial.println(temp);
  } else {
    Serial.println("Error sending message :(");
    //Serial.println("(you may send a limited amount of messages per minute, depending on the signal strength");
   //Serial.println("it may vary from 1 message every couple of seconds to 1 message every minute)");
  }
  delay(1000);
  
  if (!modem.available()) {
    Serial.println("No downlink message received at this time.");
    return;
  }
  
  char rcv[64];
  int i = 0;
  while (modem.available()) {
    rcv[i++] = (char)modem.read();
  }
  
  Serial.print("Received: ");
  for (unsigned int j = 0; j < i; j++) {
    Serial.print(rcv[j] >> 4, HEX);
    Serial.print(rcv[j] & 0xF, HEX);
    Serial.print(" ");
  }
  
  Serial.println();

  delay(120000); //Wait two minutes to send updated temp value.
}

//this function deals with requesting data from the sensor and converting it to a readable format
float getTemperature()
{ 
  
  Wire.requestFrom(tempsensorAddress,2); //here we request 2 bytes from the temperature sensor
  byte MSB = Wire.read();//the Most Significant Byte is received first
  byte LSB = Wire.read();//the Least Significant Byte is received second
  int TemperatureSum = ((MSB << 8) | LSB) >> 4; //the temperature information is stored as a 12bit integer, using two's compliment for the negative range.
  float celsius = TemperatureSum*0.0625; //the sensor returns the temperature as a 12 bit number, the sensor has a resolution of 0.0625 Celsius
  return celsius; //causes the function to return the value when called.
}
