;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;
;	$Id: g_clg.asm,v 1.6 2015-01-23 07:07:31 stefano Exp $
;

;Usage: g_clg()

		INCLUDE "graphics/grafix.inc"    ; Contains fn defs

		PUBLIC    g_clg

		EXTERN	graybit1
		EXTERN	graybit2

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
