/*  OSCA FLOS fcntl lib
 *
 * 	delete file
 *
 *	Stefano Bodrato - March 2012
 *
 *	$Id: remove.c$
*/

#include <stdio.h>
#include <flos.h>

int remove(char *name)
{
	erase_file(name);
}
