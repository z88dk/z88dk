;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
; 	This routine gives the size of memory used by BASIC variables
;
;	$Id: zx_var_length.asm,v 1.3 2016-06-26 20:32:09 dom Exp $
;

        SECTION code_clib
	PUBLIC	zx_var_length
	PUBLIC	_zx_var_length
	
zx_var_length:
_zx_var_length:

	ld	de,($4010) 	; VARS :  location of variables
	ld	hl,($4014)	; E-Line is end of VARS
	sbc	hl,de
	dec	hl	; let's make it simple...
	ret
