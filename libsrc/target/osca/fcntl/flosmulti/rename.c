/*  OSCA FLOS fcntl lib
 *
 * 	rename file
 *
 *	Stefano Bodrato - March 2012
 *
 *	$Id: rename.c$
 */

#include <stdio.h>
#include <flos.h>


int rename(char *oldname, char *newname)
{
	erase_file(newname);
	if (rename_file(oldname, newname) == 0) return 0;
    return (-1);
}
