;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;	$Id: grpage.asm,v 1.3 2015-01-19 01:32:49 pauloscustodio Exp $
;
;
; A trick to be used with the dafault graph functions
;
; IN:  A=Page Number (0/1)
; all registers are saved

		PUBLIC	graypage
		
                EXTERN    base_graphics
		EXTERN	graybit1
		EXTERN	graybit2
		
.graypage
		push	hl
		and	a
		jr	nz,flippage
		ld	hl,(graybit1)
		ld	(base_graphics),hl
		pop	hl
		ret
.flippage
		ld	hl,(graybit2)
		ld	(base_graphics),hl
		pop	hl
		ret
