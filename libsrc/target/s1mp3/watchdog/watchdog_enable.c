
#include <ATJ2085_Ports.h>
#include <drivers/watchdog.h>
#include <drivers/ioport.h>

void __FASTCALL__ WATCHDOG_Enable( unsigned int timeout )
{
#asm
	ld	  a, WATCHDOG_ENABLE
	or	  a, l
	out	  (WATCHDOG_REG), a
#endasm			
}
