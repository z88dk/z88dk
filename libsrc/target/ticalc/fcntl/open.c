// Empathic Qubit - Jan. 2023

#include "ticalc_fcntl.h"
#include <fcntl.h>
#include <errno.h>

__asm
	INCLUDE "../../../../lib/target/ti83p/def/Ti83p.def"
__endasm;

static unsigned int create_app_var(char *name, unsigned int length) {
	__asm
	rst 0x28
	DEFW _MemChk

	ld de,hl

	ld iy,2
	add iy,sp

	ld l,(iy)
	ld h,(iy+1)

; Compare length requested with available memory
	or a
	sbc hl,de
	add hl,de
	jr c,_create_app_var_enough_memory
	jr z,_create_app_var_enough_memory
	ld hl,0
	ld IY,_IY_TABLE
	ret
._create_app_var_enough_memory
; Load OP1 with token and name
	ld a,AppVarObj
	ld (OP1),a

; Preserve length
	exx

	ld l,(iy+2)
	ld h,(iy+3)
	ld de,OP1+1
	ld bc,8
	ldir

	ld IY,_IY_TABLE

	exx

	rst 0x28
	DEFW _CreateAppVar

; Return the pointer to the memory location
	ld HL,DE
	__endasm;
}

/** Open AppVar as a file on TI Calculator
 *	@param mode
 *	O_RDONLY = 0,
 *	O_WRONLY = 1,
 *	O_APPEND = 256
 *	@return handle to file
 */
int open(char *name, int flags, mode_t mode) {
	if(!_ti_files_initialized) {
		for(unsigned int fd = MIN_FD; fd < MAX_FILES; fd++) {
			_ti_opened_files[fd].open = 0;
		}
		_ti_files_initialized = 1;
	}

	unsigned char fd = 0;
	for(fd = MIN_FD; fd < MAX_FILES; fd++) {
		if(_ti_opened_files[fd].open) {
			continue;
		}
	}

	TIFILE *file = &_ti_opened_files[fd];
	file->open = 1;

	unsigned long addr = _ti_chk_find_sym(name);
	if(!addr) {
		if(mode == O_RDONLY) {
			file->open = 0;
			errno = ESTAT;
			return -1;
		}

		addr = create_app_var(name, 0);
		if(!addr) {
			file->open = 0;
			errno = EINVAL;
			return -1;
		}
	}

	file->position = 0;
	file->mode = mode;
	file->size = 0xffff;
	// If we have a ROM page, we're archived and there is extra
	// junk at the beginning of the file
	if(addr >> 16) {
		file->ref = addr + 9;

		unsigned char namelen = readbyte(fd);

		file->ref += 1 + namelen;
		file->position = 0;
	}
	else {
		file->ref = addr;
	}

	if(read(fd, &file->size, sizeof(file->size)) < sizeof(file->size)) {
		file->open = 0;
		errno = ESTAT;
		return -1;
	}

	file->ref += 2;
	file->position = 0;

	return fd;
}
