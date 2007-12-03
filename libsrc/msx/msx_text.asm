;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	int msx_text();
;
;	Switch to text mode
;
;	$Id: msx_text.asm,v 1.1 2007-12-03 07:29:39 stefano Exp $
;

	XLIB	msx_text
	LIB	msxbios
	
msx_text:

	ld	ix,00D2h	;BIOS call for "text mode"
	jp	msxbios
