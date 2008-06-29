;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 22/06/2006
;
; 	This routine gives the length of the current BASIC program.
; 	Memory used by variables is not included.
;
;	$Id: zx_basic_length.asm,v 1.1 2008-06-29 08:25:46 aralbrec Exp $
;

	XLIB	zx_basic_length
	
zx_basic_length:

	ld	de,($5c53) 	; PROG :location of BASIC program 
	ld	hl,($5c4b)	; VARS :location of variables
	sbc	hl,de
	ret
