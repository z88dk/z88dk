;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 22/06/2006
;	Fixed by Antonio Schifano, Dec 2008
;
; 	This routine gives the length of the current BASIC program.
; 	Memory used by variables is not included.
;
;	$Id: zx_basic_length.asm,v 1.3 2015-01-19 01:33:07 pauloscustodio Exp $
;

	PUBLIC	zx_basic_length
	
zx_basic_length:

	ld	de,($5c53) 	; PROG :location of BASIC program 
	ld	hl,($5c4b)	; VARS :location of variables
	and	a
	sbc	hl,de
	ret
