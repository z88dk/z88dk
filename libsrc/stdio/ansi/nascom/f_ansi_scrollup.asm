;
; 	ANSI Video handling for the NASCOM1/2
;
;	Scrollup
;
;	Stefano Bodrato - Jul 2004
;
;
;	$Id: f_ansi_scrollup.asm,v 1.3 2015-01-19 01:33:18 pauloscustodio Exp $
;


	PUBLIC	ansi_SCROLLUP

.ansi_SCROLLUP
	
	; first line
	ld	hl,$80a
	ld	de,$bca
	ld	bc,48
	ldir

	; remaining lines
	ld	a,14
	ld	hl,$80a
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
