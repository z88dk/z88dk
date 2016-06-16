;
; 	Keyboard routines for the Commodore 128 (Z80 mode)
;	By Stefano Bodrato - 27/08/2001
;
;	getk() Read key status
;
;	$Id: savecia.asm,v 1.3 2016-06-16 21:13:07 dom Exp $
;

		SECTION code_clib
		PUBLIC	_savecia
		PUBLIC	SaveA


.savecia
._savecia
	; save CIA registers
	ld	bc,$DC00+2	;cia1+ciaDataDirA
	in	a,(c)
	ld	hl,SaveA
	ld	(hl),a
	
	inc	bc		;cia1+ciaDataDirB
	in	a,(c)
	inc	hl		;SaveB
	ld	(hl),a
	ret

	SECTION	bss_clib
.SaveA  defw  0
