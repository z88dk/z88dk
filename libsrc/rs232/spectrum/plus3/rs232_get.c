/*
 *	z88dk RS232 Function
 *
 *	ZX Spectrum plus version
 *	Reference: zfst terminal emulator by Russell Marks
 *
 *	unsigned char rs232_get(char *)
 *
 *	Returns RS_ERROR_OVERFLOW on error (and sets carry)
 */


#include <rs232.h>


u8_t rs232_get(i8_t *char)
{	/* fastcall so implicit push */
#asm
.getchar

	defc	romsend = $205b
	defc	romrecv = $1e78
	defc	bank2	= $1ffd
	defc	bank678 = $5b67

	push	af
	call	brkcheck
	call	page_romin
	pop	af
	call	romrecv
	push	af
	call	page_romout
	pop	af

	pop	de
	ld	hl,RS_ERR_NO_DATA
	ret	c
	ld	(de),a
	ld	hl,RS_ERR_OK
	push	bc		;any rubbish will do

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



