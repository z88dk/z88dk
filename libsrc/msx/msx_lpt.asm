;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_lpt();
;
;	Check if the line printer is ready (1=ready, 0 if not)
;
;	$Id: msx_lpt.asm,v 1.1 2007-12-13 11:28:42 stefano Exp $
;

	XLIB	msx_lpt
	LIB     msxbios
	
        INCLUDE "#msxbios.def"

msx_lpt:
	ld	ix,LPTSTT
	call	msxbios
	ld	hl,0
	ret	z
	inc	l
	ret
