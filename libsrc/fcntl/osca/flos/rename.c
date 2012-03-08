/*  OSCA FLOS fcntl lib
 *
 * 	rename file
 *
 *	Stefano Bodrato - March 2012
 *
 *	$Id: rename.c,v 1.1 2012-03-08 07:16:46 stefano Exp $
 */

//#include <stdio.h>
#include <flos.h>


int rename(char *oldname, char *newname)
{
	if (rename_file(oldname, newname) == 0) return 0;
    return (-1);
}
