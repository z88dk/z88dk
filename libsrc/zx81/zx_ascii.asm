;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	convert char to ASCII
;
;	unsigned char zx_ascii(unsigned char character);
;
;
;	$Id: zx_ascii.asm,v 1.2 2007-12-10 10:29:25 stefano Exp $
;	

XLIB	zx_ascii
LIB	zx81toasc

zx_ascii:
	; __FASTCALL__ :  HL = location of char
	call	zx81toasc
	ld	h,0
	ld	l,a
	ret
