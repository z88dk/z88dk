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

#include <fcntl.h>

// "stdio.h" contains definition for EOF
#include <stdio.h>
#include <trsdos.h>

int readbyte(int fd)
{

	struct TRSDOS_FILE *trs80_file;
	int buffer;

	trs80_file = (void *) fd;
	
	buffer = (trsdos_get(&trs80_file->fcb));

	if (buffer == -1)
		return_c -1;
	else
		return_nc (unsigned char)buffer;

}
