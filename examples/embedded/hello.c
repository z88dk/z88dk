#include <stdio.h>
#include "ns16450.h"

main()
{
#if defined(__EMBEDDED)
	init_uart(0,1);
#endif
	printf("Hello world!");
}
