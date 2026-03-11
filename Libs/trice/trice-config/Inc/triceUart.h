/*! \file triceUart.h
\author Thomas.Hoehenleitner [at] seerose.net
*******************************************************************************/

#ifndef TRICE_UART_H_
#define TRICE_UART_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "trice.h"

#if TRICE_DEFERRED_UARTA == 1
#include "main.h"

TRICE_INLINE uint32_t triceTxDataRegisterEmptyUartA(void) {
    // HAL_GPIO_WritePin(LED_DEBUG_2_GPIO_Port, LED_DEBUG_2_Pin, GPIO_PIN_SET);
    return __HAL_UART_GET_FLAG(TRICE_UARTA, UART_FLAG_TXE);
}

//! Write value v into trice transmit register.
//! \param v byte to transmit
//! User must provide this function.
TRICE_INLINE void triceTransmitData8UartA(uint8_t v) {
    HAL_GPIO_TogglePin(LED_DEBUG_2_GPIO_Port, LED_DEBUG_2_Pin);
    HAL_UART_Transmit(TRICE_UARTA, &v, 1, HAL_MAX_DELAY);
}

//! Allow interrupt for empty trice data transmit register.
//! User must provide this function.
TRICE_INLINE void triceEnableTxEmptyInterruptUartA(void) {
    // HAL_GPIO_WritePin(LED_DEBUG_2_GPIO_Port, LED_DEBUG_2_Pin, GPIO_PIN_SET);
    __HAL_UART_ENABLE_IT(TRICE_UARTA, UART_IT_TXE);
}

//! Disallow interrupt for empty trice data transmit register.
//! User must provide this function.
TRICE_INLINE void triceDisableTxEmptyInterruptUartA(void) {
    // HAL_GPIO_TogglePin(LED_DEBUG_2_GPIO_Port, LED_DEBUG_2_Pin);
    __HAL_UART_DISABLE_IT(TRICE_UARTA, UART_IT_TXE);
}

#endif

#ifdef __cplusplus
}
#endif

#endif /* TRICE_UART_H_ */