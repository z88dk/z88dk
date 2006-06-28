;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 22/06/2006
;
; 	This routine gives the size of memory used by BASIC variables
;
;	$Id: zx_var_length.asm,v 1.1 2006-06-28 22:21:26 stefano Exp $
;

	XLIB	zx_var_length
	
zx_var_length:

	ld	de,(23627) 	; VARS :  location of variables
	ld	hl,(23641)	; E-line: edit area is end of VARS
	sbc	hl,de
	dec	hl
	ret
