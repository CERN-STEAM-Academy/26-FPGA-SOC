/*
 * platform.h
 *
 * FPGA SoCs: Unleashing the Next Generation of Embedded Systems
  *
 */

#ifndef SRC_PLATFORM_H_
#define SRC_PLATFORM_H_



#include "xgpio.h"
#include "xparameters.h"

void init_platform();
void cleanup_platform();
int platform_setup_gpio();



/////////////
//GPIO device definition - See Vivado HW project or xparameters.h file under "include" of bsp for check right names
/////////

//GPIO DEVICE list
#define GPIO_RED          XPAR_AXI_GPIO_RED_DEVICE_ID
#define GPIO_GREEN        XPAR_AXI_GPIO_GREEN_DEVICE_ID
#define GPIO_BLUE         XPAR_AXI_GPIO_BLUE_DEVICE_ID

// prevents polluting the global namespace
namespace GPIO_Dev {
	extern XGpio Red;
	extern XGpio Green;
	extern XGpio Blue;
}

extern u8 redInt;
extern u8 greenInt;
extern u8 blueInt;

//Useful definitions
#define GPIO_OUT 0x00
#define GPIO_IN 0xFF

#define CH1 1
#define CH2 2

#endif /* SRC_PLATFORM_H_ */
