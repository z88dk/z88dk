;
;	written by Waleed Hasan
;

	XLIB	DsFillScreen

.DsFillScreen	
;
; LCD memory pattern fill
; C - entry point
	pop	bc
	pop	hl
	ld	d,l
	push	bc
	push	bc
;
; LCD memory pattern fill
; ASM - entry point
;
; i/p	: d = fill pattern
; uses	: AF,BC,HL,DE
	ld	hl,$a000

	ld	e,1		; pattern mask
	ld	b,120		; number of lines
.scrFillLoop
	push	bc
	ld	b,30
.scrFillLine
	ld	a,d
	and	e
	jr	z,skipFill
	ld	(hl),d
.skipFill
	inc	hl
	djnz	scrFillLine
	pop	bc
	rlc	e
	djnz	scrFillLoop
	
	ret

