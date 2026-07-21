/*
 * main.cc
 *
 * FPGA SoCs: Unleashing the Next Generation of Embedded Systems
 *
 */


#include "platform.h"

int main()
{

	//Platform and interrupts initialization
	init_platform();
	platform_enable_interrupts();

	//Run forever
	while(1){}

	cleanup_platform();
	return 0;
}
