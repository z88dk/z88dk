;
;	MSX specific routines
;	by Stefano Bodrato, 29/11/2007
;
;	int msx_vpeek(int address);
;
;	Read the MSX video memory
;
;	$Id: msx_vpeek.asm,v 1.1 2007-12-03 07:29:40 stefano Exp $
;

	XLIB	msx_vpeek
	LIB	msxbios
	
msx_vpeek:
	; (FASTCALL) -> HL = address
	ld	ix,$4A	; RDVRM
	call	msxbios
	ld	h,0
	ld	l,a
	ret
