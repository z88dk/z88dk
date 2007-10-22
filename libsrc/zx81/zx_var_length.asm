;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
; 	This routine gives the size of memory used by BASIC variables
;
;	$Id: zx_var_length.asm,v 1.1 2007-10-22 17:06:13 stefano Exp $
;

	XLIB	zx_var_length
	
zx_var_length:

	ld	de,($4010) 	; VARS :  location of variables
	ld	hl,($4014)	; E-Line is end of VARS
	sbc	hl,de
	dec	hl	; let's make it simple...
	ret
