/*  OSCA FLOS fcntl lib
 *
 * 	delete file
 *
 *	Stefano Bodrato - March 2012
 *
 *	$Id: remove.c,v 1.1 2012-03-08 07:16:46 stefano Exp $
*/

//#include <fcntl.h>

//#include <stdio.h>
#include <flos.h>

int remove(char *name)
{
	erase_file(name);

}
