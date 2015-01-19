;
;       Amstrad CPC pseudo-Gray Library Functions
;
;       Written by Stefano Bodrato - June 2004
;
;	$Id: grpage.asm,v 1.2 2015-01-19 01:32:49 pauloscustodio Exp $
;
;
; A trick to be used with the dafault graph functions
;
; IN:  A=Page Number (0/1)
; all registers are saved


		PUBLIC	graypage
		
                EXTERN    base_graphics
		EXTERN	grayaltpage
		
.graypage
		and	a
		jr	nz,flippage
		ld	a,0			; NOP
		ld	(grayaltpage),a
		ret
.flippage
		ld	a,$17			; RLA
		ld	(grayaltpage),a
		ret

