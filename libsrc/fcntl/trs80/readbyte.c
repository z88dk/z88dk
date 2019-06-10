/*
 *	Read byte from a TRS-80 file
 *	Stefano Bodrato - 2019
 *
 *	Not user callable - internal LIB routine
 *
 *	Enter with de = filehandle
 *
 *	$Id: readbyte.c $
*/

//#include <fcntl.h>

// "stdio.h" contains definition for EOF
#include <stdio.h>
#include <trsdos.h>


int readbyte(int handle)
{

	struct TRSDOS_FILE *trs80_file;
	
	
	trs80_file = (void *) handle;
	
	// trsdos_get() picks a byte or -1 (= EOF)
	return (trsdos_get(trs80_file->fcb));

}
