/*
 *	long lseek(int fd, long posn, int whence)
 *
 *	Based on the generic version, crap and slow
 *
 *	0	SEEK_SET from start of file
 *	1	SEEK_CUR from current position
 *	2	SEEK_END from end of file (always -ve)
 *
 *	$Id: lseek.c $
*/

#include <fcntl.h>
#include <stdio.h>
#include <trsdos.h>


long lseek(int fd, long posn, int whence)
{
	long	position;
	struct TRSDOS_FILE *trs80_file;


	trs80_file = (void *) fd;
	
	if (whence == SEEK_SET) {
		trsdos(DOS_CLOSE, 0, trs80_file->fcb);
		trsdos_tst(DOS_OPEN_NEW, trs80_file->buffer, trs80_file->fcb);
	}
		
	if (whence == SEEK_END) {
		position=0;
		while (trsdos_get(trs80_file->fcb)!=-1) position++;
	}
	else {
		for ( position=0; (position!=posn) && (trsdos_get(trs80_file->fcb)!=-1); position++);
	}
	
	return (position);
}
