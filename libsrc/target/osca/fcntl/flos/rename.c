/*  OSCA FLOS fcntl lib
 *
 * 	rename file
 *
 *	Stefano Bodrato - March 2012
 *
 *	$Id: rename.c,v 1.2 2012-06-19 06:46:03 stefano Exp $
 */

//#include <stdio.h>
#include <flos.h>


int rename(char *oldname, char *newname)
{
	erase_file(newname);
	if (rename_file(oldname, newname) == 0) return 0;
    return (-1);
}
