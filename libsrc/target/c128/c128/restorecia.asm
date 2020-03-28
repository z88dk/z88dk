;
;	$Id: restorecia.asm,v 1.3 2016-06-16 21:13:07 dom Exp $
;

		SECTION code_clib
		PUBLIC	restorecia
		PUBLIC	_restorecia
		EXTERN	SaveA

.restorecia
._restorecia

	; restore CIA registers
	ld	bc,$D02F
	ld	a,7
	out	(c),a

	ld	bc,$DC00+2	;cia1+ciaDataDirA
	ld	hl,SaveA
	ld	a,(hl)
	out	(c),a
	
	inc	bc		;cia1+ciaDataDirB
	inc	hl
	ld	a,(hl)		; SaveB
	out	(c),a
	ret

