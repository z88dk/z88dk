/*
 *	Remove file from Microdrive
 *	fixed on first drive, for now.
 *
 *	Stefano Bodrato - Feb. 2005
 *
 *	$Id: remove.c,v 1.2 2005-03-01 17:50:37 stefano Exp $
*/

//#include <fcntl.h>

#include <stdio.h>
#include <zxinterface1.h>

int remove(char *name)
{
	if1_remove_file (1, name);

}
