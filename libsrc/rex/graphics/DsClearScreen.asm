;
;	written by Waleed Hasan
;

	XLIB	DsClearScreen


.DsClearScreen
	ld	hl,$a000
	ld	bc,30*120
.clrLoop
	ld	(hl),0
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jr	nz,clrLoop
		
	ret
