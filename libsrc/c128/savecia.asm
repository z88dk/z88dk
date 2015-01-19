;
; 	Keyboard routines for the Commodore 128 (Z80 mode)
;	By Stefano Bodrato - 27/08/2001
;
;	getk() Read key status
;
;	$Id: savecia.asm,v 1.2 2015-01-19 01:32:42 pauloscustodio Exp $
;


		PUBLIC	savecia
		PUBLIC	SaveA

.SaveA  defw  0

.savecia
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

