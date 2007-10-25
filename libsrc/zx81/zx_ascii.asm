;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	convert char to ASCII
;
;	unsigned char zx_ascii(unsigned char character);
;
;
;	$Id: zx_ascii.asm,v 1.1 2007-10-25 14:53:04 stefano Exp $
;	

XLIB	zx_ascii
LIB	zx81toasc

zx_ascii:
	pop	de
	pop	hl	; location of char
	push	hl
	push	de
	call	zx81toasc
	ld	h,0
	ld	l,a
	ret
