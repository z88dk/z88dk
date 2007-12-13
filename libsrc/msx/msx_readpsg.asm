;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_readpsg(int regno);
;
;	Read the specified PSG register
;
;
;	$Id: msx_readpsg.asm,v 1.1 2007-12-13 11:28:42 stefano Exp $
;

	XLIB	msx_readpsg
	LIB     msxbios
	
        INCLUDE "#msxbios.def"

msx_readpsg:
	ld	a,l
	ld	ix,RDPSG
	call	msxbios
	ld	h,0
	ld	l,a
	ret
