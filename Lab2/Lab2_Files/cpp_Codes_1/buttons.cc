/*
 * buttons.cc
 *
 *  FPGA SoCs: Unleashing the Next Generation of Embedded Systems
 *  
 */

#include "buttons.h"
#include "platform.h"


//Interrupt function for Push Button "RED"
void functionIsrRed(void *InstancePtr)
{

	XGpio *GpioPtr = (XGpio *) InstancePtr;

	// Disable the interrupt
	XGpio_InterruptDisable(GpioPtr, IR_CH1_MASK);

//	// There should not be any other interrupts occurring
	if ((XGpio_InterruptGetStatus(GpioPtr) & IR_CH1_MASK) != IR_CH1_MASK) {
		XGpio_InterruptEnable(GpioPtr, IR_CH1_MASK); // re-enable before leaving, or this button dies forever
		return;
	}

	//Do something between here
	//use redInt

	//...and here

	// Clear the interrupt such that it is no longer pending in the GPIO
	(void) XGpio_InterruptClear(GpioPtr, IR_CH1_MASK);

	//Enable the interrupt
	XGpio_InterruptEnable(GpioPtr, IR_CH1_MASK);

}

//Interrupt function for Push Button "GREEN"
void functionIsrGreen(void *InstancePtr)
{
	XGpio *GpioPtr = (XGpio *) InstancePtr;

	// Disable the interrupt
	XGpio_InterruptDisable(GpioPtr, IR_CH1_MASK);

//	// There should not be any other interrupts occurring
	if ((XGpio_InterruptGetStatus(GpioPtr) & IR_CH1_MASK) != IR_CH1_MASK) {
		XGpio_InterruptEnable(GpioPtr, IR_CH1_MASK); // re-enable before leaving, or this button dies forever
		return;
	}

	//Do something between here
	//use greenInt

	//...and here

	// Clear the interrupt such that it is no longer pending in the GPIO
	(void) XGpio_InterruptClear(GpioPtr, IR_CH1_MASK);

	//Enable the interrupt
	XGpio_InterruptEnable(GpioPtr, IR_CH1_MASK);

}

//Interrupt function for Push Button "BLUE"
void functionIsrBlue(void *InstancePtr)
{

	XGpio *GpioPtr = (XGpio *) InstancePtr;

	// Disable the interrupt
	XGpio_InterruptDisable(GpioPtr, IR_CH1_MASK);

//	// There should not be any other interrupts occurring
	if ((XGpio_InterruptGetStatus(GpioPtr) & IR_CH1_MASK) != IR_CH1_MASK) {
		XGpio_InterruptEnable(GpioPtr, IR_CH1_MASK); // re-enable before leaving, or this button dies forever
		return;
	}

	//Do something between here
	//use blueInt

	//...and here

	// Clear the interrupt such that it is no longer pending in the GPIO
	(void) XGpio_InterruptClear(GpioPtr, IR_CH1_MASK);

	//Enable the interrupt
	XGpio_InterruptEnable(GpioPtr, IR_CH1_MASK);

}

//Interrupt function for Push Button "CTRL"
//void functionIsrCtrl(void *InstancePtr)
//{
//
//	XGpio *GpioPtr = (XGpio *) InstancePtr;
//
//	// Disable the interrupt
//	XGpio_InterruptDisable(GpioPtr, IR_CH1_MASK);
//
////	// There should not be any other interrupts occurring
//	if ((XGpio_InterruptGetStatus(GpioPtr) & IR_CH1_MASK) != IR_CH1_MASK) {
//		return;
//	}
//
//	//Do something between here
//
//
//	//...and here
//
//	// Clear the interrupt such that it is no longer pending in the GPIO
//	(void) XGpio_InterruptClear(GpioPtr, IR_CH1_MASK);
//
//	//Enable the interrupt
//	XGpio_InterruptEnable(GpioPtr, IR_CH1_MASK);
//
//}



