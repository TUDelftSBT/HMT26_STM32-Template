#include "app.h"


void app_init(void) {
    // Initialization of the application
    // TriceInit();
    // #if !TRICE_OFF
    // SysTick->CTRL |= SysTick_CTRL_TICKINT_Msk; // enable SysTick interrupt
    // #endif
}

void app_loop(void) {
    // TRice("Fun %x!\n", 0xadded ); // with "fixed" iD(170), 32-bit stamp, and with `\n`
    // TRice("What %x!\n", 0xadded ); // with "fixed" iD(170), 32-bit stamp, and with `\n`
    // TriceTransfer(); // call cycl

    char d[] = "Hello world from uart interrupts!";
    HAL_UART_Transmit_IT(&huart2, (uint8_t *) d, sizeof(d));
    HAL_GPIO_TogglePin(LED_DEBUG_2_GPIO_Port, LED_DEBUG_2_Pin);
    HAL_Delay(500);
}
