;
; 	Keyboard routines for the Commodore 128 (Z80 mode)
;	By Stefano Bodrato - 27/08/2001
;
;	getk() Read key status
;
;	$Id: restorecia.asm,v 1.2 2015-01-19 01:32:42 pauloscustodio Exp $
;

		PUBLIC	restorecia
		EXTERN	SaveA

.restorecia

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

