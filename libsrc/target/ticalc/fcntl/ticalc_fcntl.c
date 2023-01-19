#include "ticalc_fcntl.h"

__asm
	INCLUDE "../../../../lib/target/ti83p/def/Ti83p.def"
__endasm;

TIFILE _ti_opened_files[MAX_FILES];
unsigned char _ti_files_initialized = 0;

unsigned char _ti_insert_mem(void* dst, unsigned int length) {
	__asm
	rst 0x28
	DEFW _MemChk

	ld de,hl

	ld iy,2
	add iy,sp

	ld l,(iy)
	ld h,(iy+1)

; Compare length requested with available memory
	sbc hl,de
	add hl,de
	jr c,_insert_mem_enough_memory
	jr z,_insert_mem_enough_memory
	ld IY,_IY_TABLE
	ld l,0
	ret
._insert_mem_enough_memory

; Load destination of memory insert
	ld e,(iy+2)
	ld d,(iy+3)

	ld IY,_IY_TABLE

    rst 0x28
    DEFW InsertMem

    ld l,1
    __endasm;
}

long _ti_chk_find_sym(char *name) __FASTCALL__ __naked {
	__asm

; Load OP1 with token and name
	ld A,AppVarObj
	ld (OP1),A

	ld DE,OP1+1
	ld bc,8
	ldir

	rst 0x28
	DEFW _ChkFindSym
	jr c,_chk_find_sym_notfound

	; Align address to format 00 page hi lo and return
	ld HL,DE
	ld E,B
	ld D,0
	ret
._chk_find_sym_notfound
; Return empty address for error
	ld de,0
	ld hl,0
	ret
	__endasm;
}
