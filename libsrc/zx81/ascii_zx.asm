;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	convert ASCII character to ZX81 char code
;
;	unsigned char ascii_zx(unsigned char character);
;
;
;	$Id: ascii_zx.asm,v 1.2 2007-12-10 10:29:25 stefano Exp $
;	

XLIB	ascii_zx
LIB	asctozx81

ascii_zx:
	; __FASTCALL__ :  HL = location of char
	call	asctozx81
	ld	h,0
	ld	l,a
	ret
