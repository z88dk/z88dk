
#ifndef __RTC_H__
#define __RTC_H__

#include <ATJ2085_Ports.h>

extern void __LIB__ RTC_Initialise(void);
extern void __LIB__ RTC_ISR(void);
extern unsigned int __LIB__ RTC_Getms(void);
extern unsigned char __LIB__ RTC_GetStatus(void);

#endif /* __RTC_H__ */

