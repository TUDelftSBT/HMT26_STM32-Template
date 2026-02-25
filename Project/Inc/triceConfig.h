// Example triceConfig.h snippet
#ifndef TRICE_CONFIG_H_
#define TRICE_CONFIG_H_

// Used to ignore the errors
#define TRICE_CLEAN 1

#define TRICE_BUFFER TRICE_DOUBLE_BUFFER
#define TRICE_DIRECT_OUTPUT 1
#define TRICE_OFF 0
#define TRICE_UART          2          // Use UART2
#define TRICE_BAUDRATE      115200     // Baudrate
#define TRICE_DMA           1          // Enable DMA (1) or Disable (0)

#define TRICE_DIRECT_SEGGER_RTT_32BIT_WRITE 1

// Windows: trice log -p com4         -ts16 "time:tick #%6d" -i ../../demoTIL.json -li ../../demoLI.json
// Unix:    trice log -p /dev/ttyACM0 -ts16 "time:tick #%6d" -i ../../demoTIL.json -li ../../demoLI.json
#define TRICE_DEFERRED_OUTPUT 1
#define TRICE_DEFERRED_UARTA 1
#define TRICE_UARTA USART2

#endif // TRICE_CONFIG_H_
