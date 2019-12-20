#include <ATJ2085_Ports.h>
#include <drivers/rtc.h>

void RTC_Initialise(void) {
#asm
	in	a, (RTC_CONTROL_REG)
	or	RTC_CONTROL_TIMER_ENABLE
	out	(RTC_CONTROL_REG), a

	in	a, (MINT_ENABLE_REG)
	or	MINT_ENABLE_RTC
	out	(MINT_ENABLE_REG), a
#endasm
}
