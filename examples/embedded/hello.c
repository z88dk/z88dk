#include <stdio.h>
#include "ns16450.h"

main()
{
	init_uart(0,1);
	printf("Hello world!");
}
