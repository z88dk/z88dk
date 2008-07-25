;
;	ZX 81 specific routines
;	by Stefano Bodrato, Oct 2007
;
; 	This routine gives the length of the current BASIC program.
; 	Memory used by variables is not included.
;
;	$Id: zx_basic_length.asm,v 1.1 2008-07-25 15:31:25 stefano Exp $
;

	XLIB	zx_basic_length
	
zx_basic_length:

	ld	de,$407D 	; location of BASIC program (just after system variables)
	ld	hl,($400C)	; Display file is end of program
	sbc	hl,de
	ret
