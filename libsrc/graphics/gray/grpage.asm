;
;       TI Gray Library Functions
;
;       Written by Stefano Bodrato - Mar 2001
;
;
; A trick to be used with the dafault graph functions
;
; IN:  A=Page Number (0/1)
; all registers are saved

		XLIB	graypage
		
                XREF    base_graphics
		XREF	graybit1
		XREF	graybit2
		
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
