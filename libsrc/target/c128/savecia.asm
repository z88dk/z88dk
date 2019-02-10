;
; 	Keyboard routines for the Commodore 128 (Z80 mode)
;	By Stefano Bodrato - 27/08/2001
;
;	getk() Read key status
;
;	$Id: savecia.asm,v 1.4 2017-01-02 19:56:32 aralbrec Exp $
;

		SECTION code_clib
      PUBLIC   savecia
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
