/*
 * Z80 test
 *
 * UART loop back
 *
 */

#include <stdio.h>
#include <math.h>
#include "ns16450.h"

int main(void)
{
	char	c;

#if defined(__EMBEDDED)
	init_uart(0,1);
#endif

	for (;;)
	{
		c = getchar();
		putchar(c);
	}
}
