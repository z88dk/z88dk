;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;
;	$Id: g_clg.asm,v 1.4 2002-04-17 21:30:25 dom Exp $
;

;Usage: g_clg()

		INCLUDE "graphics/grafix.inc"    /* Contains fn defs */

		XLIB    g_clg

		XREF	graybit1
		XREF	graybit2

.g_clg
	  	ld	hl,(graybit1)
	  	call	cls
	  	
	  	ld	hl,(graybit2)
.cls
		ld	(hl),0
		ld	d,h
		ld	e,l
		inc	de
		ld	bc,row_bytes*64-1
		ldir

		ret
