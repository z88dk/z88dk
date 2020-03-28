
/*
 *  FCNTL library for the TRS-80
 *	Stefano Bodrato - 2019
 *
 *	int close(int file_descriptor)
 *	closes file and frees memory
 *
 *	$Id: close.c $
 */

#include <fcntl.h>

//#include <stdio.h>
#include <malloc.h>
#include <trsdos.h>



int close(int fd)
{

	struct TRSDOS_FILE *trs80_file;


	trs80_file = (void *) fd;
	
	if ((trs80_file == TRSDOS_DO) || (trs80_file == TRSDOS_PR) || (trs80_file == TRSDOS_KI))
		return 0;

	/* Let's close the file only if TRSDOS thinks it is open */
	if (trs80_file->fcb.type & 0x80) {
		trsdos(DOS_CLOSE, 0, trs80_file->fcb);
	}
	free(fd);

	return 0;

}
