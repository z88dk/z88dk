/*
 *	z88dk RS232 Function
 *
 *	ZX Spectrum plus version
 *	Reference: zfst terminal emulator by Russell Marks
 *
 *	unsigned char rs232_get(char *)
 *
 *	Returns RS_ERROR_OVERFLOW on error (and sets carry)
 *
 *      $Id: rs232_get.c,v 1.4 2014-10-30 10:26:48 stefano Exp $
 */


#include <rs232.h>


u8_t __FASTCALL__ rs232_get(i8_t *char)
{	/* fastcall so implicit push */
#asm
.getchar

	; better to chk the "break" condition ourselves
	; (old entry points not used anymore)
	;defc	romrecv = 0x1e78
	;defc	romrecv2 = 0x06f7

	defc	romrecv = 0x1e8c
	defc	romrecv2 = 0x0707
	
	defc	serfl = $5b61
	
	LIB   zx_break
	LIB   rs232_page_romin
	LIB   rs232_page_romout

	ld	hl,serfl
	ld	a,(hl)	; Is the second-character received flag set?
	jr	z,readchar
	ld	(hl),0
	inc hl
	ld	a,(hl)	; pick the character we already got
	scf			; C flag == success
	jr	p2mode
	
.readchar
	call  zx_break
;	jr    c,nobreak
;
;	ld	hl,RS_ERR_BREAK
;	ret
;
;.nobreak
	ld		a,(romrecv2)
	cp		$f3		; look for the DI instruction presence
	jr		nz,p3mode

	call	romrecv2
	jr		p2mode
	
.p3mode
	call	rs232_page_romin
	call	romrecv
	push	af
	call	rs232_page_romout
	pop	af

.p2mode
	pop	de
	ld	hl,RS_ERR_NO_DATA
	ret	nc

	ld	(de),a
	ld	hl,RS_ERR_OK
	ret


#endasm
}



