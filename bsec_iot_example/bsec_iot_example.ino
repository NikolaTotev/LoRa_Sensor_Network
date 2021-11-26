/*
   Copyright (C) 2017 Robert Bosch. All Rights Reserved.

   Disclaimer

   Common:
   Bosch Sensortec products are developed for the consumer goods industry. They may only be used
   within the parameters of the respective valid product data sheet.  Bosch Sensortec products are
   provided with the express understanding that there is no warranty of fitness for a particular purpose.
   They are not fit for use in life-sustaining, safety or security sensitive systems or any system or device
   that may lead to bodily harm or property damage if the system or device malfunctions. In addition,
   Bosch Sensortec products are not fit for use in products which interact with motor vehicle systems.
   The resale and/or use of products are at the purchasers own risk and his own responsibility. The
   examination of fitness for the intended use is the sole responsibility of the Purchaser.

   The purchaser shall indemnify Bosch Sensortec from all third party claims, including any claims for
   incidental, or consequential damages, arising from any product use not covered by the parameters of
   the respective valid product data sheet or not approved by Bosch Sensortec and reimburse Bosch
   Sensortec for all costs in connection with such claims.

   The purchaser must monitor the market for the purchased products, particularly with regard to
   product safety and inform Bosch Sensortec without delay of all security relevant incidents.

   Engineering Samples are marked with an asterisk (*) or (e). Samples may vary from the valid
   technical specifications of the product series. They are therefore not intended or fit for resale to third
   parties or for use in end products. Their sole purpose is internal client testing. The testing of an
   engineering sample may in no way replace the testing of a product series. Bosch Sensortec
   assumes no liability for the use of engineering samples. By accepting the engineering samples, the
   Purchaser agrees to indemnify Bosch Sensortec from all claims arising from the use of engineering
   samples.

   Special:
   This software module (hereinafter called "Software") and any information on application-sheets
   (hereinafter called "Information") is provided free of charge for the sole purpose to support your
   application work. The Software and Information is subject to the following terms and conditions:

   The Software is specifically designed for the exclusive use for Bosch Sensortec products by
   personnel who have special experience and training. Do not use this Software if you do not have the
   proper experience or training.

   This Software package is provided `` as is `` and without any expressed or implied warranties,
   including without limitation, the implied warranties of merchantability and fitness for a particular
   purpose.

   Bosch Sensortec and their representatives and agents deny any liability for the functional impairment
   of this Software in terms of fitness, performance and safety. Bosch Sensortec and their
   representatives and agents shall not be liable for any direct or indirect damages or injury, except as
   otherwise stipulated in mandatory applicable law.

   The Information provided is believed to be accurate and reliable. Bosch Sensortec assumes no
   responsibility for the consequences of use of such Information nor for any infringement of patents or
   other rights of third parties which may result from its use. No license is granted by implication or
   otherwise under any patent or patent rights of Bosch. Specifications mentioned in the Information are
   subject to change without notice.

   It is not allowed to deliver the source code of the Software to any third party without permission of
   Bosch Sensortec.

*/

/*!
   @file bsec_iot_example.ino

   @brief
   Example for using of BSEC library in a fixed configuration with the BME680 sensor.
   This works by running an endless loop in the bsec_iot_loop() function.
*/

/*!
   @addtogroup bsec_examples BSEC Examples
   @brief BSEC usage examples
   @{*/

/**********************************************************************************************************************/
/* header files */
/**********************************************************************************************************************/

#include "bsec_integration.h"
#include "config/generic_33v_3s_4d/bsec_serialized_configurations_iaq.h"
#include <Wire.h>

/**********************************************************************************************************************/
/* functions */
/**********************************************************************************************************************/

/*!
   @brief           Write operation in either Wire or SPI

   param[in]        dev_addr        Wire or SPI device address
   param[in]        reg_addr        register address
   param[in]        reg_data_ptr    pointer to the data to be written
   param[in]        data_len        number of bytes to be written

   @return          result of the bus communication function
*/
int8_t bus_write(uint8_t dev_addr, uint8_t reg_addr, uint8_t *reg_data_ptr, uint16_t data_len)
{
  Wire.beginTransmission(dev_addr);
  Wire.write(reg_addr);    /* Set register address to start writing to */

  /* Write the data */
  for (int index = 0; index < data_len; index++) {
    Wire.write(reg_data_ptr[index]);
  }

  return (int8_t)Wire.endTransmission();
}

/*!
   @brief           Read operation in either Wire or SPI

   param[in]        dev_addr        Wire or SPI device address
   param[in]        reg_addr        register address
   param[out]       reg_data_ptr    pointer to the memory to be used to store the read data
   param[in]        data_len        number of bytes to be read

   @return          result of the bus communication function
*/
int8_t bus_read(uint8_t dev_addr, uint8_t reg_addr, uint8_t *reg_data_ptr, uint16_t data_len)
{
  int8_t comResult = 0;
  Wire.beginTransmission(dev_addr);
  Wire.write(reg_addr);                    /* Set register address to start reading from */
  comResult = Wire.endTransmission();

  delayMicroseconds(150);                 /* Precautionary response delay */
  Wire.requestFrom(dev_addr, (uint8_t)data_len);    /* Request data */

  int index = 0;
  while (Wire.available())  /* The slave device may send less than requested (burst read) */
  {
    reg_data_ptr[index] = Wire.read();
    index++;
  }

  return comResult;
}

/*!
   @brief           System specific implementation of sleep function

   @param[in]       t_ms    time in milliseconds

   @return          none
*/
void sleep(uint32_t t_ms)
{
  delay(t_ms);
}

/*!
   @brief           Capture the system time in microseconds

   @return          system_current_time    current system timestamp in microseconds
*/
int64_t get_timestamp_us()
{
  return (int64_t) millis() * 1000;
}

/*!
   @brief           Handling of the ready outputs

   @param[in]       timestamp       time in nanoseconds
   @param[in]       iaq             IAQ signal
   @param[in]       iaq_accuracy    accuracy of IAQ signal
   @param[in]       temperature     temperature signal
   @param[in]       humidity        humidity signal
   @param[in]       pressure        pressure signal
   @param[in]       raw_temperature raw temperature signal
   @param[in]       raw_humidity    raw humidity signal
   @param[in]       gas             raw gas sensor signal
   @param[in]       bsec_status     value returned by the bsec_do_steps() call

   @return          none
*/
void output_ready(int64_t timestamp, float iaq, uint8_t iaq_accuracy, float temperature, float humidity,
                  float pressure, float raw_temperature, float raw_humidity, float gas, bsec_library_return_t bsec_status,
                  float static_iaq, float co2_equivalent, float breath_voc_equivalent)
{
  Serial.print("[");
  Serial.print(timestamp / 1e6);
  Serial.print("] T: ");
  Serial.print(temperature);
  Serial.print("| rH: ");
  Serial.print(humidity);
  Serial.print("| gas: ");
  Serial.print(gas);
  Serial.print("| IAQ: ");
  Serial.print(iaq);
  Serial.print(" (");
  Serial.print(iaq_accuracy);
  Serial.print("| Static IAQ: ");
  Serial.print(static_iaq);
  Serial.print("| CO2e: ");
  Serial.print(co2_equivalent);
  Serial.print("| bVOC: ");
  Serial.println(breath_voc_equivalent);
}

/*!
   @brief           Load previous library state from non-volatile memory

   @param[in,out]   state_buffer    buffer to hold the loaded state string
   @param[in]       n_buffer        size of the allocated state buffer

   @return          number of bytes copied to state_buffer
*/
uint32_t state_load(uint8_t *state_buffer, uint32_t n_buffer)
{
  // ...
  // Load a previous library state from non-volatile memory, if available.
  //
  // Return zero if loading was unsuccessful or no state was available,
  // otherwise return length of loaded state string.
  // ...
  return 0;
}

/*!
   @brief           Save library state to non-volatile memory

   @param[in]       state_buffer    buffer holding the state to be stored
   @param[in]       length          length of the state string to be stored

   @return          none
*/
void state_save(const uint8_t *state_buffer, uint32_t length)
{
  // ...
  // Save the string some form of non-volatile memory, if possible.
  // ...
}

/*!
   @brief           Load library config from non-volatile memory

   @param[in,out]   config_buffer    buffer to hold the loaded state string
   @param[in]       n_buffer        size of the allocated state buffer

   @return          number of bytes copied to config_buffer
*/
uint32_t config_load(uint8_t *config_buffer, uint32_t n_buffer)
{
  // ...
  // Load a library config from non-volatile memory, if available.
  //
  // Return zero if loading was unsuccessful or no config was available,
  // otherwise return length of loaded config string.
  // ...

  memcpy(config_buffer, bsec_config_iaq, sizeof(bsec_config_iaq));
  Serial.println("config_load done");
  return sizeof(bsec_config_iaq);
}

/*!
   @brief       Main function which configures BSEC library and then reads and processes the data from sensor based
                on timer ticks

   @return      result of the processing
*/
void setup()
{
  return_values_init ret;

  /* Init I2C and serial communication */
  Wire.begin();
  Serial.begin(115200);

  /* Call to the function which initializes the BSEC library
     Switch on low-power mode and provide no temperature offset */
  ret = bsec_iot_init(BSEC_SAMPLE_RATE_LP, 0.0f, bus_write, bus_read, sleep, state_load, config_load);

  bsec_sensor_configuration_t   virtualSensors[BSEC_NUMBER_OUTPUTS];
  bsec_sensor_configuration_t   sensorSettings[BSEC_MAX_PHYSICAL_SENSOR];
  uint8_t                       nVirtualSensors = 0;
  uint8_t                       nSensorSettings = BSEC_MAX_PHYSICAL_SENSOR;

  bsec_virtual_sensor_t sensorList2[10];
  sensorList2[0] = BSEC_OUTPUT_RAW_TEMPERATURE;
  sensorList2[1] = BSEC_OUTPUT_RAW_PRESSURE;
  sensorList2[2] = BSEC_OUTPUT_RAW_HUMIDITY;
  sensorList2[3] = BSEC_OUTPUT_SENSOR_HEAT_COMPENSATED_TEMPERATURE;
  sensorList2[4] = BSEC_OUTPUT_SENSOR_HEAT_COMPENSATED_HUMIDITY;
  sensorList2[5] = BSEC_OUTPUT_CO2_EQUIVALENT;
  sensorList2[6] = BSEC_OUTPUT_BREATH_VOC_EQUIVALENT;
  sensorList2[7] = BSEC_OUTPUT_RAW_GAS;
  sensorList2[8] = BSEC_OUTPUT_IAQ;
  sensorList2[9] = BSEC_OUTPUT_STATIC_IAQ;

  for (uint8_t i = 0; i < 10; i++) {
    virtualSensors[nVirtualSensors].sensor_id = sensorList2[i];
    virtualSensors[nVirtualSensors].sample_rate = BSEC_SAMPLE_RATE_LP;
    nVirtualSensors++;
  }

  bsec_update_subscription(virtualSensors, nVirtualSensors, sensorSettings, &nSensorSettings);

  if (ret.bme680_status)
  {
    /* Could not intialize BME680 */
    Serial.println("Error while initializing BME680");
    return;
  }
  else if (ret.bsec_status)
  {
    /* Could not intialize BSEC library */
    Serial.println("Error while initializing BSEC library");
    return;
  }

  /* Call to endless loop function which reads and processes data based on sensor settings */
  /* State is saved every 10.000 samples, which means every 10.000 * 3 secs = 500 minutes  */
  bsec_iot_loop(sleep, get_timestamp_us, output_ready, state_save, 10000);
}

void loop()
{
}

/*! @}*/
