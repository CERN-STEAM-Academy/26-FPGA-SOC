/*
 * main.cc
 *
 * FPGA SoCs: Unleashing the Next Generation of Embedded Systems
 * 
 *
 */


#include "platform.h"
#include "pwm.h"
#include "xuartps.h"
#include <cstdlib>

#include <stdio.h>

#define R "\x52"
#define G "\x47"
#define B "\x42"
#define C "\x43"

int main()
{

	xil_printf("Hello I'm PYNQ-Z2 and I'm Alive!\n");
	//Platform and interrupts initialization (does nothing)
	init_platform();
	platform_enable_interrupts();


	//"Working" period for LEDs
	periodRed = 256000;
	periodGreen = 256000;
	periodBlue = 256000;


	//Default setting for duty cycles
	dutyRed = 128000;
	dutyGreen = 128000;
	dutyBlue= 128000;

	//First set of PWMs
	setRedPWM();
	setGreenPWM();
	setBluePWM();

	//Create payload array for Serial Data
	u8 payload[4];

	int j=0;
	char number[3];

	//Run forever
	while(1){

		//Receive 1 Byte from UART-Serial port
		payload[j] = XUartPs_RecvByte(STDIN_BASEADDRESS);

		//Send back received byte in order to visualize it on computer's terminal
		XUartPs_SendByte(STDOUT_BASEADDRESS, payload[j]);


		if(j>0 && j <4) {
			number[j-1] = payload[j];
		}

		if (j==3) {

			//Useful  new line
			xil_printf("\n");

			switch (payload[0]) {

				//Set RED
				case R[0] :
				//Convert 3 bytes into integer + coefficient correction
				dutyRed = atoi(number)*1000;
				setRedPWM();
				xil_printf("Set Red to %d!\n", dutyRed);
				break;

				//Set GREEN
				case G[0] :
				//Convert 3 bytes into integer + coefficient correction
				dutyGreen = atoi(number)*1000;
				setGreenPWM();
				xil_printf("Set Green to %d!\n", dutyGreen);
				break;

				//Set BLUE
				case B[0] :
				//Convert 3 bytes into integer + coefficient correction
				dutyBlue =  atoi(number)*1000;
				setBluePWM();
				xil_printf("Set Blue to %d!\n", dutyBlue);
				break;

				//Default CASE
				default:
				xil_printf("UNKNOWN COMMAND!!\n");
				break;

			}

			j=0;
			xil_printf("Clear UART Buffer...\n");
		}

		else
			++j;

	}

	cleanup_platform();
	return 0;
}
