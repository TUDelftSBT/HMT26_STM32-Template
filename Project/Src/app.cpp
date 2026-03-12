#include "app.h"


void app_init(void) {
    // Initialization of the application
    // TriceInit();
    // #if !TRICE_OFF
    // SysTick->CTRL |= SysTick_CTRL_TICKINT_Msk; // enable SysTick interrupt
    // #endif
}

void app_loop(void) {
    // trice("Hello world!");
    // TriceTransfer(); // serve deferred output<<<

    char c = 'A';
    HAL_UART_Transmit(&huart2, (uint8_t*)&c, 1, HAL_MAX_DELAY);
}
