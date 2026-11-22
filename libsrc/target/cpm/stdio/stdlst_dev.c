/*
 * Extra MSG device for stdlst
 */

#define STDIO_ASM
#include <stdio.h>
#include <cpm.h>

#asm
	SECTION code_clib
	PUBLIC	_stdlst_device
        EXTERN  __bdos


_stdlst_device:
	cp	__STDIO_MSG_PUTC
	jr	z,handle_putc
        cp      __STDIO_MSG_WRITE
        jr      z,handle_write
	scf	; error
	ret


; Entry: ix = fp
;	 bc = character
; Exit: hl = result
handle_putc:
	ld	e,c
	ld	c,CPM_WLST
	call	__bdos
	and	a
	ret

; ix = fp
; de = buf,
; bc = length
handle_write:
	ex	de,hl
loop:
	push	bc
	push	hl
	ld	e,(hl)
	ld	c,CPM_WLST
	call	__bdos
	pop	hl
	inc	hl
	pop	bc
	dec	bc
	ld	a,b
	or	c
	jr	nz,loop
	and	a
	ret
#endasm#endasm#endasm
