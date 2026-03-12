#include "app.h"


void app_init(void) {
    TriceInit();

    // Enable systicks for timestamps in trice
    SystemCoreClockUpdate(); 
    const uint32_t once_every_ms = SystemCoreClock / 1000;
    SysTick_Config(once_every_ms);
 
    Trice("INFO: Initialisation complete. Trice is also working! :) \n");
}

void app_loop(void) {
    TRice("Ping from Trice\n");
    TriceTransfer();

    HAL_GPIO_TogglePin(LED_DEBUG_2_GPIO_Port, LED_DEBUG_2_Pin);
    HAL_Delay(1000);
}
