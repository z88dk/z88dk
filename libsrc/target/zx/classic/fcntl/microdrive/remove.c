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
#include <arch/zx/zxinterface1.h>

int remove(char *name)
{
  // Exit if 'microdrive not present' or 'write protected'
	if (if1_mdv_status(if1_driveno(name))) return (-1);

	if1_remove_file (if1_driveno(name), if1_filename(name));
}
