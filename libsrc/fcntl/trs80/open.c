/*
 *	Open a file on TRS-80
 *	Stefano Bodrato - 2019
 *
 *	int open(char *name, int flags, mode_t mode)
 *	returns handle to file
 *
 *
 *	Access is either
 *
 *	O_RDONLY = 0
 *	O_WRONLY = 1    Starts afresh?!?!?
 *	O_APPEND = 256
 *
 *	$Id: open.c $
 */

#include <fcntl.h>
#include <trsdos.h>

//#include <stdio.h>
#include <malloc.h>
#include <string.h>




int open(char *name, int flags, mode_t mode)
{

struct TRSDOS_FILE *trs80_file;

	if (stricmp(name,"*DO") == 0) {
		if (flags == O_RDONLY)
			return (-1);
		/* Fake TRSDOS_FILE structure, no buffer, point to an already open FCB (the video DCB) */
		return (TRSDOS_DO);
	}

	if (stricmp(name,"*PR") == 0) {
		if (flags == O_RDONLY)
			return (-1);
		/* Fake TRSDOS_FILE structure, no buffer, point to an already open FCB (the printer DCB) */
		return (TRSDOS_PR);
	}

	if (stricmp(name,"*KI") == 0) {
		if (flags != O_RDONLY)
			return (-1);
		/* Fake TRSDOS_FILE structure, no buffer, point to an already open FCB (the keyboard DCB) */
		return (TRSDOS_KI);
	}
	
	trs80_file = malloc(sizeof(struct TRSDOS_FILE));
	if (trs80_file == 0) return (-1);

	/* Prepare FCB */
	//if (!trsdos_tst(DOS_FSPEC, name, trs80_file->fcb)) {
	if (!initdcb (name, trs80_file->fcb)) {

		if (flags == O_RDONLY) {
			/* Open existing file and return immediately, nonzero result = error */
				if ( !trsdos_tst(DOS_OPEN_EX, trs80_file->buffer, trs80_file->fcb) ) {
					return (trs80_file);
				}
		}

		if (flags == O_WRONLY) {
			/* Delete file (if existing and not device name.. thus ignore errors), then open */
				// if ( name[0] != '*'  ) // << is this necessary ?
				trsdos_tst(DOS_OPEN_EX, 0, trs80_file->fcb);
				trsdos_tst(DOS_KILL, 0, trs80_file->fcb);
				//};
		}

		if ( ((flags & O_WRONLY) != 0) || ((flags & O_APPEND) != 0) ) {
			/* Open existing file for writing, otherwise create a new one */
				initdcb (name, trs80_file->fcb);
				if ( !trsdos_tst(DOS_OPEN_NEW, trs80_file->buffer, trs80_file->fcb) ) {
					if (flags & O_APPEND) while (trsdos_get(trs80_file->fcb)!=-1) {}
					return (trs80_file);
				}
		}
		
	}
		
	/* catch-all error exit code */
	free(trs80_file);
	return(-1);


}

