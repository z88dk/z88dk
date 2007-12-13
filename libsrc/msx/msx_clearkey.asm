;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	void msx_clearkey();
;
;	Clears the keyboard buffer
;
;	$Id: msx_clearkey.asm,v 1.1 2007-12-13 11:28:42 stefano Exp $
;

	XLIB	msx_clearkey
	LIB     msxbios
	
        INCLUDE "#msxbios.def"

msx_clearkey:
	ld	ix,KILBUF
	jp	msxbios
