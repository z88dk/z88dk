;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;
;	$Id: g_clg.asm,v 1.7 2017-01-02 22:57:58 aralbrec Exp $
;

;Usage: g_clg()

		INCLUDE "graphics/grafix.inc"    ; Contains fn defs

		PUBLIC    g_clg
      PUBLIC    _g_clg

		EXTERN	graybit1
		EXTERN	graybit2

.g_clg
._g_clg
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
