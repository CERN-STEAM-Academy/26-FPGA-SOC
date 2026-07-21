/*
 * platform.cc
 *
 * FPGA SoCs: Unleashing the Next Generation of Embedded Systems
 *
 */


#include "platform.h"

#include "xil_printf.h"
#include "xgpio.h"
#include "xparameters.h"
#include "xil_cache.h"

XGpio GPIO_Dev::Red;
XGpio GPIO_Dev::Green;
XGpio GPIO_Dev::Blue;

u8 redInt;
u8 greenInt;
u8 blueInt;

//Setup GPIO devices
int platform_setup_gpio()
{
	xil_printf("Setup AXI GPIO\r\n");
	int numberOfDevice = 3;
	int Status[numberOfDevice];

	//Initialize the GPIO driver
	Status[0] = XGpio_Initialize(&GPIO_Dev::Red, GPIO_RED);
	Status[1] = XGpio_Initialize(&GPIO_Dev::Green, GPIO_GREEN);
	Status[2] = XGpio_Initialize(&GPIO_Dev::Blue, GPIO_BLUE);

	//Status initialize
	for(int i=0; i<numberOfDevice; i++) {
		if (Status[i] != XST_SUCCESS) {
			return XST_FAILURE;
		}
	}

	//Set direction (input or output) for all GPIO devices

	//Set OUT
	XGpio_SetDataDirection(&GPIO_Dev::Red, CH1, GPIO_OUT);
	XGpio_SetDataDirection(&GPIO_Dev::Green, CH1, GPIO_OUT);
	XGpio_SetDataDirection(&GPIO_Dev::Blue, CH1, GPIO_OUT);

	return 0;
}

//Initialize platform
void init_platform()
{
    platform_setup_gpio();

	//Write default values
    redInt = 100;
    greenInt = 100;
    blueInt = 100;

    XGpio_DiscreteWrite(&GPIO_Dev::Red, CH1, redInt);
    XGpio_DiscreteWrite(&GPIO_Dev::Green, CH1, greenInt);
    XGpio_DiscreteWrite(&GPIO_Dev::Blue, CH1, blueInt);

    return;
}


//Cleanup Platform
void cleanup_platform()
{
    Xil_ICacheDisable();
    Xil_DCacheDisable();
    return;
}
