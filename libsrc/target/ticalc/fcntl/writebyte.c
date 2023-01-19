// Empathic Qubit - Jan. 2023
#include <fcntl.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>

#include "ticalc_fcntl.h"

/**
 * Write a byte sequentially to an AppVar on TI calculator
 */
int writebyte(int fd, int byte) __smallc {
	TIFILE *file = &_ti_opened_files[fd];

	if(!file->open || file->mode == O_RDONLY || file->page) {
		errno = EACCES;
		// We can't write to read-only or archived, yet
		return -1;
	}

	unsigned int new_size = file->position + 1;
	if(new_size > file->size) {
		// This is different than the one in read(), because if we fail
		// we can't write anything.
		if(!_ti_insert_mem(file->ref + file->size, 1)) {
			errno = EFBIG;
			return -1;
		}
		*(unsigned int*)(file->ref - 2) = file->size = new_size;
	}

	*(unsigned char *)(file->offset + file->position) = (unsigned char)byte;
	file->position++;

	return 0;
}
