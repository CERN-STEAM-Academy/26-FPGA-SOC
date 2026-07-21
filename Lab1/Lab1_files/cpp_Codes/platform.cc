/*
 * platform.cc
 *
 *  FPGA SoCs: Unleashing the Next Generation of Embedded Systems
 *
 */

#include "platform.h"
#include "buttons.h"

#include "xil_printf.h"
#include "xgpio.h"
#include "xparameters.h"
#include "xil_cache.h"

#include "xscugic.h"
#define INTC_BASE_ADDR      XPAR_SCUGIC_CPU_BASEADDR
#define INTC_DIST_BASE_ADDR XPAR_SCUGIC_DIST_BASEADDR

XGpio GPIO_Dev::Red;
XGpio GPIO_Dev::Green;
XGpio GPIO_Dev::Blue;
XGpio GPIO_Dev::Ctrl;

//Setup GPIO devices
int platform_setup_gpio()
{
	int numberOfDevice = 4;
	int Status[numberOfDevice];

	//Initialize the GPIO driver
	Status[0] = XGpio_Initialize(&GPIO_Dev::Red, GPIO_RED);
	Status[1] = XGpio_Initialize(&GPIO_Dev::Green, GPIO_GREEN);
	Status[2] = XGpio_Initialize(&GPIO_Dev::Blue, GPIO_BLUE);
	Status[3] = XGpio_Initialize(&GPIO_Dev::Ctrl, GPIO_CTRL);

	//Status initialize
	for(int i=0; i<numberOfDevice; i++) {
		if (Status[i] != XST_SUCCESS) {
			return XST_FAILURE;
		}
	}

	//Set direction (input or output) for all GPIO devices
	//Set IN
	XGpio_SetDataDirection(&GPIO_Dev::Red, CH1, GPIO_IN);
	XGpio_SetDataDirection(&GPIO_Dev::Green, CH1, GPIO_IN);
	XGpio_SetDataDirection(&GPIO_Dev::Blue, CH1, GPIO_IN);
	XGpio_SetDataDirection(&GPIO_Dev::Ctrl, CH1, GPIO_IN);
	//Set OUT
	XGpio_SetDataDirection(&GPIO_Dev::Red, CH2, GPIO_OUT);
	XGpio_SetDataDirection(&GPIO_Dev::Green, CH2, GPIO_OUT);
	XGpio_SetDataDirection(&GPIO_Dev::Blue, CH2, GPIO_OUT);
	XGpio_SetDataDirection(&GPIO_Dev::Ctrl, CH2, GPIO_OUT);

	return 0;
}

//Setup Interrupts
void platform_setup_interrupts(void)
{

    Xil_ExceptionInit();

    XScuGic_DeviceInitialize(INTC_DEVICE_ID);

    /*
     * Connect the interrupt controller interrupt handler to the hardware
     * interrupt handling logic in the processor.
     */
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT,
            (Xil_ExceptionHandler)XScuGic_DeviceInterruptHandler,
            (void *)INTC_DEVICE_ID);

    /*
     * Connect the device driver handler that will be called when an
     * interrupt for the device occurs, the handler defined above performs
     * the specific interrupt processing for the device.
     */

    /*Interrupt for Red GPIO**/
    XScuGic_SetPriTrigTypeByDistAddr(INTC_BASE_ADDR, INTC_INTERRUPT_RED_ID, 0xA0, 0x3);
    XScuGic_RegisterHandler(INTC_BASE_ADDR, INTC_INTERRUPT_RED_ID,
                    (Xil_ExceptionHandler)functionIsrRed,
                    (void *) &GPIO_Dev::Red);
    XScuGic_EnableIntr(INTC_DIST_BASE_ADDR, INTC_INTERRUPT_RED_ID);


    /*Interrupt for Green GPIO**/
    XScuGic_SetPriTrigTypeByDistAddr(INTC_BASE_ADDR, INTC_INTERRUPT_GREEN_ID, 0xA0, 0x3);
    XScuGic_RegisterHandler(INTC_BASE_ADDR, INTC_INTERRUPT_GREEN_ID,
                    (Xil_ExceptionHandler)functionIsrGreen,
                    (void *) &GPIO_Dev::Green);
    XScuGic_EnableIntr(INTC_DIST_BASE_ADDR, INTC_INTERRUPT_GREEN_ID);


    /*Interrupt for Blue GPIO**/
    XScuGic_SetPriTrigTypeByDistAddr(INTC_BASE_ADDR, INTC_INTERRUPT_BLUE_ID, 0xA0, 0x3);
    XScuGic_RegisterHandler(INTC_BASE_ADDR, INTC_INTERRUPT_BLUE_ID,
                    (Xil_ExceptionHandler)functionIsrBlue,
                    (void *) &GPIO_Dev::Blue);
    XScuGic_EnableIntr(INTC_DIST_BASE_ADDR, INTC_INTERRUPT_BLUE_ID);


    /*Interrupt for Ctrl GPIO**/
    XScuGic_SetPriTrigTypeByDistAddr(INTC_BASE_ADDR, INTC_INTERRUPT_CTRL_ID, 0xA0, 0x3);
    XScuGic_RegisterHandler(INTC_BASE_ADDR, INTC_INTERRUPT_CTRL_ID,
                    (Xil_ExceptionHandler)functionIsrCtrl,
                    (void *) &GPIO_Dev::Ctrl);
    XScuGic_EnableIntr(INTC_DIST_BASE_ADDR, INTC_INTERRUPT_CTRL_ID);

    return;
}

//Enable Interrupts
void platform_enable_interrupts()
{
    /*
     * Enable non-critical exceptions.
     */
    Xil_ExceptionEnable();


    //Enable All Interrupts
    XGpio_InterruptEnable(&GPIO_Dev::Red, IR_CH1_MASK);
    XGpio_InterruptEnable(&GPIO_Dev::Green, IR_CH1_MASK);
    XGpio_InterruptEnable(&GPIO_Dev::Blue, IR_CH1_MASK);
    XGpio_InterruptEnable(&GPIO_Dev::Ctrl, IR_CH1_MASK);

    XGpio_InterruptGlobalEnable(&GPIO_Dev::Red);
    XGpio_InterruptGlobalEnable(&GPIO_Dev::Green);
    XGpio_InterruptGlobalEnable(&GPIO_Dev::Blue);
    XGpio_InterruptGlobalEnable(&GPIO_Dev::Ctrl);

    return;
}

//Initialize platform
void init_platform()
{
    platform_setup_gpio();
    platform_setup_interrupts();
    return;
}

//Cleanup Platform
void cleanup_platform()
{
    Xil_ICacheDisable();
    Xil_DCacheDisable();
    return;
}




