;
; 	ANSI Video handling for the ZX81
;	By Stefano Bodrato - Apr. 2000
;
; 	CLS - Clear the screen
;	

	XLIB	ansi_cls

.ansi_cls

        ld	hl,(16396)
	ld	a,118
	ld	(hl),a
	ld	c,24
.drow
	inc	hl
	ld	b,32
	ld	a,128
.dcol	ld	(hl),a
	inc	hl
	djnz	dcol
	ld	a,118
	ld	(hl),a
	dec	c
	jr	nz,drow
	ret
