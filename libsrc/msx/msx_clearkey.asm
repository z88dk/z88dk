;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	void msx_clearkey();
;
;	Clears the keyboard buffer
;
;	$Id: msx_clearkey.asm,v 1.2 2009-05-21 06:58:11 stefano Exp $
;

	XLIB	msx_clearkey
	LIB     msxbios
	
IF FORmsx
        INCLUDE "#msxbios.def"
ELSE
        INCLUDE "#svibios.def"
ENDIF

msx_clearkey:
	ld	ix,KILBUF
	jp	msxbios
