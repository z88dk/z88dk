;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 22/06/2006
;	Fixed by Antonio Schifano, Dec 2008
;
; 	This routine gives the size of memory used by BASIC variables
;
;	$Id: zx_var_length.asm,v 1.4 2016-06-10 20:02:04 dom Exp $
;

	SECTION code_clib
	PUBLIC	zx_var_length
	PUBLIC	_zx_var_length
	
zx_var_length:
_zx_var_length:

	ld	de,(23627) 	; VARS :  location of variables
	ld	hl,(23641)	; E-line: edit area is end of VARS
	and	a
	sbc	hl,de
	dec	hl
	ret
