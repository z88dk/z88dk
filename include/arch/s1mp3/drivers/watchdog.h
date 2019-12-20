
#ifndef __WATCHDOG_H__
#define __WATCHDOG_H__

#include <ATJ2085_Ports.h>

#define WD_180s   WATCHDOG_180S
#define WD_90s    WATCHDOG_90S
#define WD_45s    WATCHDOG_45S	
#define WD_22_2s  WATCHDOG_22_2S
#define WD_5_6s   WATCHDOG_5_6S	
#define WD_1_4s   WATCHDOG_1_4S
#define WD_0_352s WATCHDOG_0_352S
#define WD_0_176s WATCHDOG_0_176S

extern void __LIB__ WATCHDOG_Enable( unsigned int timeout );
extern void __LIB__ WATCHDOG_Disable( void );
extern void __LIB__ WATCHDOG_Reset( void );

#endif /* __WATCHDOG_H__ */
