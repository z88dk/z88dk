/*
 *	Remove file from Microdrive
 *	fixed on first drive, for now.
 *
 *	Stefano Bodrato - Feb. 2005
 *
 *	$Id: remove.c $
*/

//#include <fcntl.h>

#include <stdio.h>
#include <zxinterface1.h>

int remove(char *name)
{
	if1_remove_file (if1_driveno(name), if1_filename(name));
}
