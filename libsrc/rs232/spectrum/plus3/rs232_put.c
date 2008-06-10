/*
 *	z88dk RS232 Function
 *
 *	ZX Spectrum plus version
 *	Reference: zfst terminal emulator by Russell Marks
 *
 *	unsigned char rs232_put(char)
 *
 *	No error checking, for now.
 *
 *      $Id: rs232_put.c,v 1.2 2008-06-10 07:59:10 stefano Exp $
 */


#include <rs232.h>


u8_t rs232_put(i8_t char)
{	/* Fastcall so implicit push */
#asm

	defc	romsend = $205b
	defc	romrecv = $1e78
	defc	bank2	= $1ffd
	defc	bank678 = $5b67

.sendchar
	ld	a,l	;get byte

        push    hl
	push	af
	call	brkcheck
	call	page_romin
	pop	af
	call	romsend
	push	af
	call	page_romout
	pop	af
        pop     hl

	ld	hl,RS_ERR_OK
	pop	bc	;remove implicit push

        ret

.page_romout
	di
	ld	bc,bank2
	ld	a,(bank678)
	set	2,a
	ld	(bank678),a
	out	(c),a
	ei
	ret

.page_romin
	di
	ld	bc,bank2
	ld	a,(bank678)
	res	2,a
	ld	(bank678),a
	out	(c),a
	ei
	ret

.brkcheck
	ld	bc,$7ffe
	in	a,(c)
	bit	0,a
	ret	nz
	ld	b,$fe
	in	a,(c)
	bit	0,a
	ret	nz
	jr	brkcheck

#endasm
}
