/*
 *	Remove file from Microdrive
 *	fixed on first drive, for now.
 *
 *	Stefano Bodrato - Feb. 2005
 *
 *	$Id: remove.c,v 1.1 2005-02-18 08:35:53 stefano Exp $
*/

//#include <fcntl.h>

#include <stdio.h>
#include <zxinterface1.h>

int remove(char *name)
{
	if1_remove_file (1, name);

}
