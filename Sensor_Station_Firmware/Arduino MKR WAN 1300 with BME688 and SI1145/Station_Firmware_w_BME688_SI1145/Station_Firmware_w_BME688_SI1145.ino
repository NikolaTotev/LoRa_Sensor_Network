#include <Wire.h>
#include <MKRWAN.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include "arduino_secrets.h"
#include "bsec.h"

LoRaModem modem;

// Uncomment if using the Murata chip as a module
// LoRaModem modem(Serial1);


String appEui = SECRET_APP_EUI;
String appKey = SECRET_APP_KEY;

#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 32 // OLED display height, in pixels

#define OLED_RESET     4 // Reset pin # (or -1 if sharing Arduino reset pin)
#define SCREEN_ADDRESS 0x3C ///< See datasheet for Address; 0x3D for 128x64, 0x3C for 128x32
#define STATE_SAVE_PERIOD  UINT32_C(360 * 60 * 1000) // 360 minutes - 4 times a day

const uint8_t bsec_config_iaq[] = {
#include "config/generic_33v_3s_4d/bsec_iaq.txt"
};

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

// Create an object of the class Bsec
Bsec iaqSensor;

String output;
int numberOfMessages = 0;


int tempsensorAddress = 0x48; //here we tell the Arduino where the sensor can be found on the I2C bus

void setup() {
  // put your setup code here, to run once:
  initDisplay();

  resetDisplay();
  display.println("LoRa Station starting.");
  display.println("Firmware version v0.1");
  display.println("Mounted sensor BME688");
  display.display();
  delay(2000);

  resetDisplay();
  display.println("Starting serial.");
  display.println("Baud Rate: 115200");
  display.display();
  delay(2000);
  
  Serial.begin(115200);
  Wire.begin();
  while (!Serial);
  
  
  
  setupModem();
  setupBME();
}

void loop() 
{
  generateAndSendPacket();
  
  delay(1000);
  
  checkForDownlink();
  
  //Wait two minutes to send updated temp value.
  delay(120000); 
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



void setupModem() {
  
  resetDisplay();
  display.println("Initializing modem.");
  display.display();
  delay(500);
  
  //Set to EU868 for europe mode.
  if (!modem.begin(EU868)) {
    Serial.println("Failed to start module");
    
    resetDisplay();
    display.println("Failed to start modem.");
    display.display();
    
    while (1) {}
  };

  Serial.print("Your module version is: ");
  Serial.println(modem.version());
  Serial.print("Your device EUI is: ");
  Serial.println(modem.deviceEUI());

  int connected = modem.joinOTAA(appEui, appKey);
  if (!connected) {
    
    resetDisplay();
    display.println("Failed to connect.");
    display.display();
    
    Serial.println("Something went wrong; are you indoor? Move near a window and retry");
    while (1) {Serial.println("WARNING: Failed to start");}
  }

  resetDisplay();
  display.println("Modem online.");
  display.display();
  
  // Set poll interval to 60 secs.
  modem.minPollInterval(60);
  // NOTE: independently by this setting the modem will
  // not allow to send more than one message every 2 minutes,
  // this is enforced by firmware and can not be changed.
}

void generateAndSendPacket() {
  
  float temperature = -1;
  float humidity = -1;
  unsigned long time_trigger = millis();
    if (iaqSensor.run()) { // If new data is available
      temperature = iaqSensor.temperature;
      humidity = iaqSensor.humidity;
      output ="";
      //output += String(iaqSensor.rawTemperature)+ " ";
      //output += String(iaqSensor.rawHumidity)+ " ";
      //output += String(iaqSensor.gasResistance)+ " ";
      output += String(iaqSensor.temperature)+ " ";
      output += String(iaqSensor.humidity)+ " ";
      output += String(iaqSensor.pressure)+ " ";
      output += String(iaqSensor.iaq)+ " ";
      output += String(iaqSensor.iaqAccuracy)+ " ";
      output += String(iaqSensor.staticIaq)+ " ";
      output += String(iaqSensor.co2Equivalent)+ " ";
      output += String(iaqSensor.breathVocEquivalent);
    } else {
      checkIaqSensorStatus();
    }

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
  Serial.println(output);
  int err;
  modem.beginPacket();
  modem.print(output);
  err = modem.endPacket(true);
  if (err > 0) {
    Serial.println("Message sent correctly!");
    Serial.println(output);
    resetDisplay();
    display.println("Message sent!");
    display.print("Message number:");
    display.print(numberOfMessages);
    display.display();
    delay(2000);

    resetDisplay();
    display.println("Basic data:");
    display.print("Temp:");
    display.println(temperature);
    display.print("Humid:");
    display.println(humidity);
    display.display();
     delay(1000);
    
  } else {
    Serial.println("Error sending message :(");
    resetDisplay();
    display.println("Failed to send message.");
    display.print("Message number:");
    display.print(numberOfMessages);
    display.display();
     delay(1000);
    //Serial.println("(you may send a limited amount of messages per minute, depending on the signal strength");
   //Serial.println("it may vary from 1 message every couple of seconds to 1 message every minute)");
  }

  numberOfMessages++;
}

void checkForDownlink() 
{
  if (!modem.available()) {
      Serial.println("No downlink message received at this time.");
    }
    else{
      char rcv[64];
      int i = 0;
      while (modem.available()) {
        rcv[i++] = (char)modem.read();
      }
      
      Serial.print("Received: ");
      for (unsigned int j = 0; j < i; j++) 
      {
        Serial.print(rcv[j] >> 4, HEX);
        Serial.print(rcv[j] & 0xF, HEX);
        Serial.print(" ");
      }
        Serial.println();
    }
}

void initDisplay() {
  // SSD1306_SWITCHCAPVCC = generate display voltage from 3.3V internally
  if(!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
    Serial.println(F("SSD1306 allocation failed"));
    for(;;); // Don't proceed, loop forever
  }

  // Show initial display buffer contents on the screen --
  // the library initializes this with an Adafruit splash screen.
  display.display();
  delay(1000); // Pause for 2 seconds

  // Clear the buffer
  display.clearDisplay();
  delay(1000);
  testfillrect();
  delay(1000);
 
}

void testfillrect(void) {
 display.clearDisplay();

  for(int16_t i=0; i<display.height()/2-2; i+=2) {
    // The INVERSE color is used so round-rects alternate white/black
    display.fillRoundRect(i, i, display.width()-2*i, display.height()-2*i,
      display.height()/4, SSD1306_INVERSE);
    display.display();
    delay(1);
  }

  delay(1000);
}

void resetDisplay (){
  display.clearDisplay();
  display.setCursor(0, 0);
  display.setTextSize(1);// Draw 2X-scale text
  display.setTextColor(SSD1306_WHITE);
}

void setupBME() {
  iaqSensor.begin(BME680_I2C_ADDR_PRIMARY, Wire);
  output = "\nBSEC library version " + String(iaqSensor.version.major) + "." + String(iaqSensor.version.minor) + "." + String(iaqSensor.version.major_bugfix) + "." + String(iaqSensor.version.minor_bugfix);
  Serial.println(output);
  checkIaqSensorStatus();

  bsec_virtual_sensor_t sensorList[10] = {
    BSEC_OUTPUT_RAW_TEMPERATURE,
    BSEC_OUTPUT_RAW_PRESSURE,
    BSEC_OUTPUT_RAW_HUMIDITY,
    BSEC_OUTPUT_RAW_GAS,
    BSEC_OUTPUT_IAQ,
    BSEC_OUTPUT_STATIC_IAQ,
    BSEC_OUTPUT_CO2_EQUIVALENT,
    BSEC_OUTPUT_BREATH_VOC_EQUIVALENT,
    BSEC_OUTPUT_SENSOR_HEAT_COMPENSATED_TEMPERATURE,
    BSEC_OUTPUT_SENSOR_HEAT_COMPENSATED_HUMIDITY,
  };

  iaqSensor.updateSubscription(sensorList, 10, BSEC_SAMPLE_RATE_LP);
  checkIaqSensorStatus();

  // Print the header
  output = "Timestamp [ms], raw temperature [°C], pressure [hPa], raw relative humidity [%], gas [Ohm], IAQ, IAQ accuracy, temperature [°C], relative humidity [%], Static IAQ, CO2 equivalent, breath VOC equivalent";
  Serial.println(output);
}


//BME Helper functions ===========================================
// Helper function definitions
void checkIaqSensorStatus(void)
{
  if (iaqSensor.status != BSEC_OK) {
    if (iaqSensor.status < BSEC_OK) {
      output = "BSEC error code : " + String(iaqSensor.status);
      Serial.println(output);
      for (;;)
        errLeds(); /* Halt in case of failure */
    } else {
      output = "BSEC warning code : " + String(iaqSensor.status);
      Serial.println(output);
    }
  }

  if (iaqSensor.bme680Status != BME680_OK) {
    if (iaqSensor.bme680Status < BME680_OK) {
      output = "BME680 error code : " + String(iaqSensor.bme680Status);
      Serial.println(output);
      for (;;)
        errLeds(); /* Halt in case of failure */
    } else {
      output = "BME680 warning code : " + String(iaqSensor.bme680Status);
      Serial.println(output);
    }
  }
}

void errLeds(void)
{
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH);
  delay(100);
  digitalWrite(LED_BUILTIN, LOW);
  delay(100);
}
