
#ifndef __ISR_H__
#define __ISR_H__

#include <ATJ2085_Ports.h>

extern void __LIB__ ISR_Initialise(void);
extern int ISR_Install(int, void *) __smallc;
extern int ISR_Remove(int);

#define ISR_HANDLER_ADC 0
#define ISR_HANDLER_KEYBOARD 2
#define ISR_HANDLER_RTC 4
#define ISR_HANDLER_DMA_CTC 6
#define ISR_HANDLER_UART 8
#define ISR_HANDLER_USB 10
#define ISR_HANDLER_I2C 12
#define ISR_HANDLER_DSP 14

#endif /* __ISR_H__ */

