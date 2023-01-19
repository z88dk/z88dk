// Empathic Qubit - Jan. 2023

#include <fcntl.h>
#include <errno.h>
#include <stdio.h>

#include "ticalc_fcntl.h"

__asm
	INCLUDE "../../../../lib/target/ti83p/def/Ti83p.def"
__endasm;

static unsigned char load_c_ind_paged(unsigned long ref) __FASTCALL__ __naked {
    __asm
	LD B,E
	rst 0x28
	DEFW _LoadCIndPaged
	LD L,C
	LD H,0
    ret
    __endasm;
}

/** Read byte from AppVar on TI Calculator */
int readbyte(int fd) __FASTCALL__ {
	TIFILE *file = &_ti_opened_files[fd];

	if(!file->open) {
		errno = EACCES;
		return -1;
	}

	if(file->position >= file->size) {
		return EOF;
	}

	unsigned long ref_current = 0;
	unsigned int *offset_current = &ref_current;

	if(file->page) {
		*offset_current = file->offset + (file->position % ARCHIVE_MIN);
		unsigned int *page_current = &((unsigned int *)(&ref_current))[1];
		*page_current = (file->page + (file->position / ARCHIVE_MIN));

		if(*offset_current >= ARCHIVE_MAX) {
			*offset_current -= ARCHIVE_MIN;
			(*page_current)++;
		}
	}
	else {
		*offset_current = file->offset + file->position;
	}

	unsigned char c = load_c_ind_paged(ref_current);
	file->position++;
	__asm
	OR A
	__endasm;
	return c;
}
