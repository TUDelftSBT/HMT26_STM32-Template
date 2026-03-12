#include "app.h"


void app_init(void) {
    // Initialization of the application
    // TriceInit();
    // #if !TRICE_OFF
    // SysTick->CTRL |= SysTick_CTRL_TICKINT_Msk; // enable SysTick interrupt
    // #endif
}

void app_loop(void) {
    TRice(iD(6558), "TRICE BROERTJE!!!!\n"); // with "fixed" iD(170), 32-bit stamp, and with `\n`
    TriceTransfer();

    HAL_GPIO_TogglePin(LED_DEBUG_2_GPIO_Port, LED_DEBUG_2_Pin);
    HAL_Delay(1000);
}
