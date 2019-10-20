/*
  Return the current RTC interrupt status
*/

#include <ATJ2085_Ports.h>
#include <drivers/rtc.h>

unsigned char RTC_GetStatus(void) {
#asm
	in	a, (RTC_IRQSTATUS_REG)
	ld	l, a
#endasm
}
