#include "app.h"


void app_init(void) {
    // Initialization of the application
    TriceInit();
    #if !TRICE_OFF
    SysTick->CTRL |= SysTick_CTRL_TICKINT_Msk; // enable SysTick interrupt
    #endif
}

void app_loop(void) {
    trice("Hello world!");
    HAL_Delay(400); 
    TriceTransfer(); // serve deferred output<<<
}
