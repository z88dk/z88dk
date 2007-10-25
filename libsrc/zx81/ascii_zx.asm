;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	convert ASCII character to ZX81 char code
;
;	unsigned char ascii_zx(unsigned char character);
;
;
;	$Id: ascii_zx.asm,v 1.1 2007-10-25 14:53:04 stefano Exp $
;	

XLIB	ascii_zx
LIB	asctozx81

ascii_zx:
	pop	de
	pop	hl	; location of char
	push	hl
	push	de
	call	asctozx81
	ld	h,0
	ld	l,a
	ret
