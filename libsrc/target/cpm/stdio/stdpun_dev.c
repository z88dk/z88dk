/*
 * Extra MSG device for stdpun
 */

#define STDIO_ASM
#include <stdio.h>
#include <cpm.h>

#asm
	SECTION code_clib
	PUBLIC	_stdpun_device
        EXTERN  __bdos


_stdpun_device:
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
	ld	c,CPM_WPUN
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
	ld	c,CPM_WPUN
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
#endasm
