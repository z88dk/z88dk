/* Program Savage;
   see Byte, Oct '87, p. 277 */

#include <stdio.h>
#include <math.h>
#include "ns16450.h"

#define ILOOP 500

int main(void)
{
	int i;
	float a;

	init_uart(0,1);

	a = 1.0;

	for(i = 0; i < ILOOP; ++i)
	{
		a = tan(atan(exp(log(sqrt(a * a)))));
		printf("A = %f\n", a);
		a += 1.0;
	}
}
