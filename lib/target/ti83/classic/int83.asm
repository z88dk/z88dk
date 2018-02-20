; Ti83 interrupt loader - by Henk Poley
; Based upon several sources, uses statvars to put the IV-table and JP
;-----------------------------------------------------------------------------
; You only need to have an interrupt marked with IntProcStart
;  at the beginning, since the on the Ti83 programs stay where
;  they are untill you quit. (you need to enable IM2 yourself)
;-----------------------------------------------------------------------------

	im	1			;
	res	6,(iy+9)		; stats not valid
	ld	a,$86			; locate vector table at $8600-$8700
	ld	i,a			;
	ld	bc,$0100		; vector table is 256 bytes 
	ld	h,a			;
	ld	l,c			; HL = $8600
	ld	d,a			;
	ld	e,b			; DE = $8601
	inc	a			; A  = $87
	ld	(hl),a			; interrupt "program" located at 8787h
	ldir				;
					;
	ld	l,a			; HL = $8787
	ld	(hl),$C3		; Put a JP IntProcStart at $8787
	inc	hl			;
	ld	(hl),IntProcStart&$FF	;
	inc	hl			;
	ld	(hl),IntProcStart/256	;


; Registers by now:
; -------------------------------------------
; A  = $87
; HL = $8789
; DE = $8701
; BC = $0000
; F  = carry flag is preserved
; -------------------------------------------
; Memory usage in statvars:
; -------------------------------------------
; $858F / $85FF - 113 bytes - free
; $8600 / $8700 - 256 bytes - IV table
; $8701 / $8786 - 134 bytes - free
; $8787 / $8789 -   3 bytes - JP IntProcStart
; $878A / $87A2 -  25 bytes - free
; -------------------------------------------
; See the interrupt routines themselves for
;  further info of memory useage.
