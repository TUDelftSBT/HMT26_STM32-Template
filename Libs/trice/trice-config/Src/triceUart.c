#include "trice.h"
#include "triceUart.h"

#include "main.h" // hardware specific definitions
#include "usart.h"

TRICE_INLINE uint32_t triceTxDataRegisterEmptyUartA(void) {
    return __HAL_UART_GET_FLAG(&huart1, UART_FLAG_TXE);
}

//! Write value v into trice transmit register.
//! \param v byte to transmit
//! User must provide this function.
TRICE_INLINE void triceTransmitData8UartA(uint8_t v) {
    HAL_UART_Transmit(&huart1, &v, 1, 100);
}

//! Allow interrupt for empty trice data transmit register.
//! User must provide this function.
TRICE_INLINE void triceEnableTxEmptyInterruptUartA(void) {
    __HAL_UART_ENABLE_IT(&huart1, UART_IT_TXE);
}

//! Disallow interrupt for empty trice data transmit register.
//! User must provide this function.
TRICE_INLINE void triceDisableTxEmptyInterruptUartA(void) {
    __HAL_UART_DISABLE_IT(&huart1, UART_IT_TXE);
}