;
;	written by Waleed Hasan
;

	XLIB	setpix
	LIB	pixaddr
	
;
; direct LCD pixel plot
; ASM entry point
;
; i/p	: D=x		E=y
; uses	: AF,BC,HL,DE
;
.setpix
	call	pixaddr
	ld	a,c
	or	(hl)
	ld	(hl),a
	
	ret