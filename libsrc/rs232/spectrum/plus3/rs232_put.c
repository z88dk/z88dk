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
 *      $Id: rs232_put.c,v 1.3 2014-10-30 10:26:48 stefano Exp $
 */


#include <rs232.h>


u8_t rs232_put(i8_t char)
{	/* Fastcall so implicit push */
#asm

	LIB   zx_break
	LIB   rs232_page_romin
	LIB   rs232_page_romout

	; better to chk the "break" condition ourselves
	; (old entry points not used anymore)
	;defc	romsend = 205b
	;defc	romsend2 = 0x08c2
	
	defc	romsend = 0x206a
	defc	romsend2 = 0x08d1

.sendchar
	ld	a,l	;get byte

	push	af
	
	ld	c,$fd
	ld	d,$ff
	ld	e,$bf
	ld	b,d
	ld	a,14
	out	(c),a	; AY reg. to control the RS232 port.

	call  zx_break
;	jr    c,nobreak
;
;	ld	hl,RS_ERR_BREAK
;	ret
;
;.nobreak
	ld		a,(romsend2+1)
	cp		$78		; look for the IN A,(C) instruction
	jr		nz,p3mode

	pop		af
	call	romsend2
	jr		p2mode
	
.p3mode
	call	rs232_page_romin
	pop	af
	call	romsend
	call	rs232_page_romout

.p2mode	
	ld	hl,RS_ERR_OK
	pop	bc	;remove implicit push
	ret


#endasm
}
