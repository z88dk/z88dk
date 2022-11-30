;
; 	ANSI Video handling for the NASCOM1/2
;
;	Scrollup
;
;	Stefano Bodrato - Jul 2004
;
;
;	$Id: f_ansi_scrollup.asm $
;

	SECTION	code_clib

	PUBLIC	ansi_SCROLLUP

	defc		CONSOLE_ROWS=16
	EXTERN		CONSOLE_DISPLAY	
              defc            TOPROW = CONSOLE_DISPLAY + (CONSOLE_ROWS - 1) * 64 + 10


.ansi_SCROLLUP
	
	; first line
	ld	hl, CONSOLE_DISPLAY + 10
	ld	de,TOPROW
	ld	bc,48
	ldir

	; remaining lines
	ld	a,14
	ld	hl, CONSOLE_DISPLAY + 10
.scrlloop
	ld	d,h
	ld	e,l
	ld	bc,$40
	add	hl,bc

	ld	bc,48
	push	hl
	ldir
	pop	hl

	dec	a
	jr	nz,scrlloop

	; clear bottom line
	ld	b,48
.clloop
	ld	(hl),' '
	inc	hl
	djnz	clloop

	ret
