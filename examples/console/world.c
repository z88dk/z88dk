/*
 *	Hello World
 */


#include <stdio.h>
#include <features.h>


main()
{
	printf("%cHello world! %d\n",12,12);
#ifdef __HAVE_KEYBOARD
	fgetc_cons();
#endif
}
