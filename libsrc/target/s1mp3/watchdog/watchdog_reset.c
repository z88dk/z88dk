#include <ATJ2085_Ports.h>
#include <drivers/watchdog.h>

/* set watchdog timer */
void WATCHDOG_Reset( void )
{
#asm
	in	a, (WATCHDOG_REG)          
	or	WATCHDOG_RESET
	out	(WATCHDOG_REG), a
#endasm   
}
