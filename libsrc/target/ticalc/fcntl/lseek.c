// Empathic Qubit - Jan. 2023

#include <fcntl.h>
#include "ticalc_fcntl.h"

/**
 * @param whence
 *	0	SEEK_SET from start of file,
 *	1	SEEK_CUR from current position,
 *	2	SEEK_END from end of file (always -ve)
 */
long lseek(int handle, long posn, int whence)
{
	TIFILE *file = &_ti_opened_files[handle];
	if(!file->open) {
		return -1;
	}

	if(whence == SEEK_SET) {
		file->position = posn;
	}
	else if(whence == SEEK_CUR) {
		file->position += posn;
	}
	else if(whence == SEEK_END) {
		file->position = file->size + posn;
	}

	if(file->position > file->size) {
		file->position = file->size;
	}

	return file->position;
}
