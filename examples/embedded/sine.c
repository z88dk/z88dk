/*
 * Z80 test
 *
 * Print stars in sine pattern
 *
 */

#include <stdio.h>
#include <math.h>
#include "ns16450.h"

int main(void)
{
	float	spunk;
	char	res;
	char	p;

	init_uart(0,1);

	while (1)
	{
		for (spunk = 0.0; spunk < 6.283; spunk = spunk + 0.1)
		{
			res = 30.0 * sin(spunk) + 40.0;
			for (p = 0; p < res; ++p)
			{
				putchar(' ');
			}
			putchar('*');
			putchar(0x0d);
			putchar(0x0a);
		}
	}
}
