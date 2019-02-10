;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
; 	This routine gives the length of the current BASIC program.
; 	Memory used by variables is not included.
;
;	$Id: zx_basic_length.asm,v 1.4 2016-06-26 20:32:08 dom Exp $
;

        SECTION code_clib
	PUBLIC	zx_basic_length
	PUBLIC	_zx_basic_length
	
zx_basic_length:
_zx_basic_length:

IF FORlambda
	ld	de,$4396 	; location of BASIC program (just after system variables)
	ld	hl,($4010) 	; VARS
ELSE
	ld	de,$407D 	; location of BASIC program (just after system variables)
	ld	hl,($400C)	; Display file is end of program
ENDIF
	sbc	hl,de
	ret
