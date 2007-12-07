;
;	MSX specific routines
;	by Stefano Bodrato, 29/11/2007
;
;	int msx_vpeek(int address);
;
;	Read the MSX video memory
;
;	$Id: msx_vpeek.asm,v 1.2 2007-12-07 11:28:59 stefano Exp $
;

	XLIB	msx_vpeek
	LIB	msxbios
	
        INCLUDE "#msxbios.def"

msx_vpeek:
	; (FASTCALL) -> HL = address
	ld	ix,RDVRM
	call	msxbios
	ld	h,0
	ld	l,a
	ret
