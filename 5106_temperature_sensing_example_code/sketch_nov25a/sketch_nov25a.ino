/*
Every effort has been made to ensure that this sketch is correct, however Kitronik accept no responsibility for
issues arising from errors / omissions in thes sketch.
(c) Kitronik Ltd - Any unauthorised copying / duplication of this code or part thereof for purposes except for use
with Kitronik project kits is not allowed without Kitroniks prior consent.
*/

#include <Wire.h> //we include the Wire library as it deals with I2C communication
int tempsensorAddress = 0x48; //here we tell the Arduino where the sensor can be found on the I2C bus

void setup(){    
  Serial.begin(9600); //in the setup we start serial communication and set the baud rate
  Wire.begin();
}

void loop()//this section prints the temperature to the serial monitor 
{
  float celsius = getTemperature();
  Serial.print("Celsius: ");
  Serial.println(celsius);
  delay(1000); //here we choose how often the temperature is printed, here it is set to once per second
}

float getTemperature() //this function deals with requesting data from the sensor and converting it to a readable format
{ 
  
  Wire.requestFrom(tempsensorAddress,2); //here we request 2 bytes from the temperature sensor
  byte MSB = Wire.read();//the Most Significant Byte is received first
  byte LSB = Wire.read();//the Least Significant Byte is received second
  int TemperatureSum = ((MSB << 8) | LSB) >> 4; //the temperature information is stored as a 12bit integer, using two's compliment for the negative range.
  float celsius = TemperatureSum*0.0625; //the sensor returns the temperature as a 12 bit number, the sensor has a resolution of 0.0625 Celsius
  return celsius; //causes the function to return the value when called.
}

