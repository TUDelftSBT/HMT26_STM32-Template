//
// Created by Teund on 02/02/2026.
//

#include "app.h"

#include "trice.h"
#include "usart.h"

void app_init(void) {
    // Initialization of the application
    TriceInit();
    trice("hello");
}

void app_loop(void) {
    __asm__("nop"); // nop does nothing

    // trice("Hello world!");
    // but cool code can go here
    const uint8_t data[1] = { 10 };
    HAL_UART_Transmit(&huart1, data, 1, 100);
    HAL_GPIO_TogglePin(LED_DEBUG_1_GPIO_Port, LED_DEBUG_1_Pin);
    HAL_Delay (400); 
}
