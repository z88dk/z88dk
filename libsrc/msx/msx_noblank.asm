;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	void msx_noblank();
;
;	Enable screen
;
;	$Id: msx_noblank.asm,v 1.1 2007-12-03 07:29:39 stefano Exp $
;

	XLIB	msx_noblank
	LIB	msxbios
	
msx_noblank:

	ld	ix,0044h	;BIOS call for ENASCR
	jp	msxbios
