#include <ATJ2085_Ports.h>
#include <drivers/mcu.h>

/* Select processor clock speed 
   MCU_CLK_DIV_NONE = full speed
*/

void MCU_Initialise( unsigned char Clock_Divider ) {
#asm
	xor	a
	or	MCU_EXT_MEM_WS_0
	or	MCU_CLK_SRC_SEL
	or	l
	out	(MCU_CLKCTRL_REG1),a
#endasm
}
