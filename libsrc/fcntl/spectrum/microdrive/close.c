/*
 *	Close a file on Microdrive
 *	Stefano Bodrato - Feb. 2005
 *
 *	int close(int handle)
 *	closes file and frees memory
 *
 *	$Id: close.c,v 1.1 2005-02-18 08:35:53 stefano Exp $
 */

#include <fcntl.h>
#include <zxinterface1.h>

//#include <stdio.h>
#include <malloc.h>

int close(int handle)
{

/* DEBUG - experiments to see how the M_CHAN structure survived
struct M_CHAN * if1_file;
if1_file = (char *) handle;
printf ("-- closing '%s' - %u --",if1_getname( (char *) if1_file->hdname ), handle);
*/

free(handle);

}

