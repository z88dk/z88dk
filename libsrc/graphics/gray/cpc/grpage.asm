;
;       Amstrad CPC pseudo-Gray Library Functions
;
;       Written by Stefano Bodrato - June 2004
;
;	$Id: grpage.asm,v 1.1 2004-06-30 12:50:57 stefano Exp $
;
;
; A trick to be used with the dafault graph functions
;
; IN:  A=Page Number (0/1)
; all registers are saved


		XLIB	graypage
		
                XREF    base_graphics
		XREF	grayaltpage
		
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

