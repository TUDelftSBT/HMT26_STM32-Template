/*! \file triceUart.h
\author Thomas.Hoehenleitner [at] seerose.net
*******************************************************************************/

#ifndef TRICE_UART_H_
#define TRICE_UART_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "trice.h"
#include "triceConfig.h"
#include "usart.h"

#include "main.h" // hardware specific definitions

TRICE_INLINE void ToggleOpticalFeedbackLED(void) {
	// LL_GPIO_TogglePin(LD2_GPIO_Port, LD2_Pin);
}

#if TRICE_DEFERRED_UARTA == 1

//! Check if a new byte can be written into trice transmit register.
//! \retval 0 == not empty
//! \retval !0 == empty
//! User must provide this function.
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
#endif

#ifdef __cplusplus
}
#endif

#endif /* TRICE_UART_H_ */