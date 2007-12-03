;
;	MSX specific routines
;	by Stefano Bodrato, 29/11/2007
;
;	void msx_vpoke(int address, int value);
;
;	Write the MSX video memory
;
;	$Id: msx_vpoke.asm,v 1.1 2007-12-03 07:29:40 stefano Exp $
;

	XLIB	msx_vpoke
	LIB	msxbios
	
msx_vpoke:
	pop	bc
	pop	de
	pop	hl
	push	hl	; VRAM address
	push	de	; value
	push	bc	; RET address
	ld	a,e
	ld	ix,$4D	; WRTVRM
	jp	msxbios
