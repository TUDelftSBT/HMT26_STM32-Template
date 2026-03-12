#include "app.h"


void app_init(void) {
    TriceInit();
    #if !TRICE_OFF
    SysTick->CTRL |= SysTick_CTRL_TICKINT_Msk; // enable SysTick interrupt
    #endif

    trice("INFO: Initialisation complete. Trice is also working! :) \n");
}

void app_loop(void) {
    TriceTransfer();

    HAL_GPIO_TogglePin(LED_DEBUG_2_GPIO_Port, LED_DEBUG_2_Pin);
    HAL_Delay(1000);
}
