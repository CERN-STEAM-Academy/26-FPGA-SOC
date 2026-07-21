/*
 * platform.h
 *
 *  FPGA SoCs: Unleashing the Next Generation of Embedded Systems
 *  
 */

#ifndef SRC_PLATFORM_H_
#define SRC_PLATFORM_H_

#include "xgpio.h"

void init_platform();
void cleanup_platform();
int platform_setup_gpio();
void platform_enable_interrupts();

#include "xparameters.h"

//The following constant maps to the name of the hardware instances that
//were created in the Vivado system.


/* Definitions for peripheral PS7_SCUGIC_0 */
#define INTC_DEVICE_ID                   XPAR_PS7_SCUGIC_0_DEVICE_ID

/* Definitions for Fabric interrupts connected to ps7_scugic_0 */
#define INTC_INTERRUPT_RED_ID         XPAR_FABRIC_AXI_GPIO_RED_IP2INTC_IRPT_INTR
#define INTC_INTERRUPT_GREEN_ID       XPAR_FABRIC_AXI_GPIO_GREEN_IP2INTC_IRPT_INTR
#define INTC_INTERRUPT_BLUE_ID        XPAR_FABRIC_AXI_GPIO_BLUE_IP2INTC_IRPT_INTR
//#define INTC_INTERRUPT_CTRL_ID        XPAR_FABRIC_AXI_GPIO_CTRL_IP2INTC_IRPT_INTR


/////////////
//GPIO device definition - See Vivado HW project or xparameters.h file under "include" of bsp for check right names
/////////

//GPIO DEVICE list
#define GPIO_RED          XPAR_AXI_GPIO_RED_DEVICE_ID
#define GPIO_GREEN        XPAR_AXI_GPIO_GREEN_DEVICE_ID
#define GPIO_BLUE         XPAR_AXI_GPIO_BLUE_DEVICE_ID
//#define GPIO_CTRL         XPAR_AXI_GPIO_CTRL_DEVICE_ID


// prevents polluting the global namespace
namespace GPIO_Dev {
	extern XGpio Red;
	extern XGpio Green;
	extern XGpio Blue;
	//extern XGpio Ctrl;
}

extern u8 redInt;
extern u8 greenInt;
extern u8 blueInt;

//Useful definitions
#define GPIO_OUT 0x00
#define GPIO_IN 0xFF

#define CH1 1
#define CH2 2

#define IR_CH1_MASK                   XGPIO_IR_CH1_MASK
#define IR_CH2_MASK                   XGPIO_IR_CH2_MASK

#endif /* SRC_PLATFORM_H_ */
