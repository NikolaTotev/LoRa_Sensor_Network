'''
******************************************************************************
  * @file    MQ5 Gas Sensor.py
  * @author  Waveshare Team
  * @version 
  * @date    2021-02-08
  * @brief   MQ5 Gas Sensor
  ******************************************************************************
  * @attention
  *
  * THE PRESENT FIRMWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
  * WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE
  * TIME. AS A RESULT, WAVESHARE SHALL NOT BE HELD LIABLE FOR ANY
  * DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING
  * FROM THE CONTENT OF SUCH FIRMWARE AND/OR THE USE MADE BY CUSTOMERS OF THE
  * CODING INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
  *
  ******************************************************************************
'''


from machine import Pin,ADC
import utime

#Select ADC input 0 (GPIO26)
ADC_ConvertedValue = machine.ADC(0)
DIN = Pin(22,Pin.IN)
conversion_factor = 3.3 / (65535)


while True :
    if(DIN.value() == 1) :
        print("Gas not leakage!")
    else :
        print("Gas leakage!")
        AD_value = ADC_ConvertedValue.read_u16() * conversion_factor
        print("The current Gas AD value = ",AD_value ,"V")
    utime.sleep(0.5)
        
        
        
        

