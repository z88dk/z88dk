;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 22/06/2006
;
; 	This routine gives the size of memory used by BASIC variables
;
;	$Id: zx_var_length.asm,v 1.1 2008-06-29 08:25:47 aralbrec Exp $
;

	XLIB	zx_var_length
	
zx_var_length:

	ld	de,(23627) 	; VARS :  location of variables
	ld	hl,(23641)	; E-line: edit area is end of VARS
	sbc	hl,de
	dec	hl
	ret
