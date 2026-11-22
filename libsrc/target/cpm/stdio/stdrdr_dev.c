/*
 * Extra MSG device for stdrdr
 */

#define STDIO_ASM
#include <stdio.h>
#include <cpm.h>

#asm
	SECTION code_clib
	PUBLIC	_stdrdr_device
        EXTERN  __bdos


_stdrdr_device:
        cp      __STDIO_MSG_GETC
        jr      z,handle_getc
	scf	; error
	ret


; ix = fp
; Exit: hl = result
;      carry set as appropriate
handle_getc:
	ld	c,CPM_RRDR
	call	__bdos
	ld	h,0
	and	a
	ret
#endasm
