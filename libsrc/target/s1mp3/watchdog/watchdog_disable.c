
#include <ATJ2085_Ports.h>
#include <drivers/watchdog.h>


void WATCHDOG_Disable( void )
{
#asm
	ld	  a, 0
	out	  (WATCHDOG_REG), a
#endasm
}
