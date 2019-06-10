/*
 *	Read byte from a TRS-80 file
 *	Stefano Bodrato - 2019
 *
 *	Not user callable - internal LIB routine
 *
 *	Enter with de = filehandle
 *
 *	$Id: writebyte.c $
*/

//#include <fcntl.h>

// "stdio.h" contains definition for EOF
#include <stdio.h>
#include <trsdos.h>


int writebyte(int handle, int byte)
{
	
	struct TRSDOS_FILE *trs80_file;


	trs80_file = (void *) handle;
	
	if (!trsdos_tst(DOS_PUT_BYTE, byte, trs80_file->fcb))
		return (0);
	else
		return (-1);

}
