/*
 * main.c
 *
 * FPGA SoCs: Unleashing the Next Generation of Embedded Systems
 *  *
 * Project 1 - Video Test Pattern Generator -> HDMI out
 *
 *
 * IMPORTANT - resolution coherency:
 *   The resolution set here (1280x720) MUST match the Video Mode
 *   configured in the Video Timing Controller (720p) and the pixel
 *   clock (FCLK_CLK1 = 71.42 MHz). A mismatch = black / unstable
 *   screen.
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xv_tpg.h"

/* Video resolution - keep in sync with the VTC Video Mode (720p) */
#define VIDEO_WIDTH   1280
#define VIDEO_HEIGHT   720

XV_tpg tpg_inst;
int Status;

int main()
{
    init_platform();

    xil_printf("\r\nFPGA SoCs - Video Test Pattern Generator\r\n");

    /* TPG initialization.
     * XPAR_V_TPG_0_DEVICE_ID is defined in xparameters.h (in the BSP).
     * If the name does not match, look it up there: with the upgraded
     * TPG IP it may appear with a different suffix. */
    Status = XV_tpg_Initialize(&tpg_inst, XPAR_V_TPG_0_DEVICE_ID);
    if (Status != XST_SUCCESS) {
        xil_printf("TPG configuration failed\r\n");
        return XST_FAILURE;
    }

    /* Resolution - MUST match the VTC (720p) */
    XV_tpg_Set_height(&tpg_inst, VIDEO_HEIGHT);
    XV_tpg_Set_width (&tpg_inst, VIDEO_WIDTH);

    /* Color space: RGB */
    XV_tpg_Set_colorFormat(&tpg_inst, 0x0);

    /* Background pattern - try the others as a micro-task:
     *   XV_tpg_Set_bckgndId(&tpg_inst, XTPG_BKGND_PBRS);
     *   XV_tpg_Set_bckgndId(&tpg_inst, XTPG_BKGND_RAINBOW_COLOR);
     */
    XV_tpg_Set_bckgndId(&tpg_inst, XTPG_BKGND_COLOR_BARS);

    /* Start the TPG (free-running) */
    XV_tpg_EnableAutoRestart(&tpg_inst);
    XV_tpg_Start(&tpg_inst);
    xil_printf("TPG started at %dx%d - connect the monitor to HDMI OUT\r\n",
               VIDEO_WIDTH, VIDEO_HEIGHT);

    cleanup_platform();
    return 0;
}
