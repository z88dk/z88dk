;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 22/06/2006
;	Fixed by Antonio Schifano, Dec 2008
;
; 	This routine gives the size of memory used by BASIC variables
;
;	$Id: zx_var_length.asm,v 1.3 2015-01-19 01:33:07 pauloscustodio Exp $
;

	PUBLIC	zx_var_length
	
zx_var_length:

	ld	de,(23627) 	; VARS :  location of variables
	ld	hl,(23641)	; E-line: edit area is end of VARS
	and	a
	sbc	hl,de
	dec	hl
	ret
