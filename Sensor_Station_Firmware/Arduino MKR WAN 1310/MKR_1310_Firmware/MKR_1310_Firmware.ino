#include <Wire.h>
#include <MKRWAN.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include "arduino_secrets.h"
#include <Adafruit_HTS221.h>
#include <Adafruit_Sensor.h>
#include "Adafruit_BMP3XX.h"

#define BMP_SCK 13
#define BMP_MISO 12
#define BMP_MOSI 11
#define BMP_CS 10

#define SEALEVELPRESSURE_HPA (1013.25)

// For SPI mode, we need a CS pin
#define HTS_CS 10
// For software-SPI mode we need SCK/MOSI/MISO pins
#define HTS_SCK 13
#define HTS_MISO 12
#define HTS_MOSI 11

Adafruit_HTS221 hts;
Adafruit_BMP3XX bmp;

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

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);


String output;
int numberOfMessages = 0;


void setup() {
  // put your setup code here, to run once:
  initDisplay();

  resetDisplay();
  display.println("LoRa Station starting.");
  display.println("Firmware version v0.1");
  display.println("Sensors HTS221 BMP388");
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
  
  //===========================================
  //HTS221 Setup ==============================
  //===========================================
  // Try to initialize!
  if (!hts.begin_I2C()) {
  //  if (!hts.begin_SPI(HTS_CS)) {
  //  if (!hts.begin_SPI(HTS_CS, HTS_SCK, HTS_MISO, HTS_MOSI)) {
    Serial.println("Failed to find HTS221 chip");
    resetDisplay();
    display.println(">> ERROR << ");
    display.println("Failed to setup HTS221!");
    display.display();
    
    while (1) { delay(10); }
  }
  Serial.println("HTS221 Found!");

//  hts.setDataRate(HTS221_RATE_1_HZ);
  Serial.print("Data rate set to: ");
  switch (hts.getDataRate()) {
   case HTS221_RATE_ONE_SHOT: Serial.println("One Shot"); break;
   case HTS221_RATE_1_HZ: Serial.println("1 Hz"); break;
   case HTS221_RATE_7_HZ: Serial.println("7 Hz"); break;
   case HTS221_RATE_12_5_HZ: Serial.println("12.5 Hz"); break;
  }
  
  //===========================================
  //BMP388 Setup ==============================
  //===========================================

    resetDisplay();
    display.println("Setting up BMP388");
    display.display();
  
  if (!bmp.begin_I2C()) {   // hardware I2C mode, can pass in address & alt Wire
  //if (! bmp.begin_SPI(BMP_CS)) {  // hardware SPI mode  
  //if (! bmp.begin_SPI(BMP_CS, BMP_SCK, BMP_MISO, BMP_MOSI)) {  // software SPI mode
    Serial.println("Could not find a valid BMP3 sensor, check wiring!");

    resetDisplay();
    display.println(">> ERROR << ");
    display.println("Failed to setup BMP388!");
    display.display();
    
    while (1);
  }

  // Set up oversampling and filter initialization
  bmp.setTemperatureOversampling(BMP3_OVERSAMPLING_8X);
  bmp.setPressureOversampling(BMP3_OVERSAMPLING_4X);
  bmp.setIIRFilterCoeff(BMP3_IIR_FILTER_COEFF_3);
  bmp.setOutputDataRate(BMP3_ODR_50_HZ);
  
  setupModem();
}

void loop() 
{

   
    generateAndSendPacket();
  
    delay(1000);
  
    checkForDownlink();
  

  delay(120000);
  
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
    float humid = -1;
    float pressure = -1;
    float altitude = -1;

      //=============================================
      //HTS221 Reading ==============================
      //=============================================
      sensors_event_t temp;
      sensors_event_t humidity;
      hts.getEvent(&humidity, &temp);// populate temp and humidity objects with fresh data
      Serial.print("Temperature: "); Serial.print(temp.temperature); Serial.println(" degrees C");
      Serial.print("Humidity: "); Serial.print(humidity.relative_humidity); Serial.println("% rH");


      //=============================================
      //BMP388 Reading ==============================
      //=============================================
      if (! bmp.performReading()) {
        Serial.println("Failed to perform reading :(");
        return;
      }
      else
      {
        Serial.print("Temperature = ");
        Serial.print(bmp.temperature);
        Serial.println(" *C");
  
        Serial.print("Pressure = ");
        Serial.print(bmp.pressure / 100.0);
        Serial.println(" hPa");
  
        Serial.print("Approx. Altitude = ");
        Serial.print(bmp.readAltitude(SEALEVELPRESSURE_HPA));
        Serial.println(" m");
      }
      

      // If new data is available
      temperature = temp.temperature;
      humid = humidity.relative_humidity;
      pressure = bmp.pressure / 100.0;
      altitude = bmp.readAltitude(SEALEVELPRESSURE_HPA);
      
      output ="";
    
      output += String(temperature)+ " ";
      output += String(humid)+ " ";
      output += String(pressure)+ " ";
      output += String(altitude);

      Serial.print("Temp:");
      Serial.print(temperature);
      Serial.print(" Humid:");
      Serial.print(humid);
      Serial.print(" Pressure:");
      Serial.print(pressure);
      Serial.print(" Altitude:");
      Serial.println(altitude);
    

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
    delay(200);

    resetDisplay();
    display.println("Basic data:");
    display.print("Temp:");
    display.print(temperature);
    display.print(" ");
    display.print("P:");
    display.println(pressure);
    display.print("Humid:");
    display.print(humid);
    display.print(" ");
    display.print("A:");
    display.println(altitude);
    display.display();
    
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
