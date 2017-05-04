; Ti83+ interrupt loader - by Henk Poley
; Based upon several sources, uses statvars to put the IV-table and JP
;-----------------------------------------------------------------------------
; Ti83+ programs
; You only need to have an interrupt marked with IntProcStart
;  at the beginning, since the on the Ti83+ programs stay where
;  they are untill you quit. (you need to enable IM2 yourself)
; Ti83+ Apps:
; You only need to have an interrupt marked with IntProcStart
;  at the beginning, and IntProcEnd at the end of your interrupt.
; Since the TIOS could swap out your page when your you execute
;  a BCALL. (you need to enable IM2 yourself)
;-----------------------------------------------------------------------------

IF !MirageOS				; If MirageOS, already in IM1
	im	1			;
ENDIF					;
	res	6,(iy+9)		; stats not valid
	ld	a,$8B			; locate vector table at $8B00-$8C00
	ld	i,a			;
	ld	bc,$0100		; vector table is 256 bytes 
	ld	h,a			;
	ld	l,c			; HL = $8B00
	ld	d,a			;
	ld	e,b			; DE = $8B01
	dec	a			; A  = $8A
	ld	(hl),a			; interrupt program located at $8A8A
	ldir				;
					;
IF TI83PLUSAPP				; If Ti83+ App we need to place the
					;  interrupt in RAM, so it doesn't
					;  get paged out with BCALLs
	ld	hl,IntProcStart		;
	ld	d,a			;
	ld	e,a			; DE = $8A8A
	ld	bc,IntProcEnd-IntProcStart
	ldir				;
ELSE					; With normal Ti83+ assembly programs
					;  things are already in RAM
	ld	h,a			; HL = $8A8A
	ld	l,a			;
	ld	(hl),$C3		; Put a JP IntProcStart at $8A8A
	inc	hl			;
	ld	(hl),IntProcStart&$FF	;
	inc	hl			;
	ld	(hl),IntProcStart/256	;
ENDIF					;

; Registers by now:
; ------------+--------------------------------------------------
;    prog     |   App
; ------------+--------------------------------------------------
; A  = $8A    | A  = $8A
; HL = $8A8C  | HL = IntProcStart + (IntProcEnd-IntProcStart)
; DE = $8C01  | DE = $8A8A        + (IntProcEnd-IntProcStart)
; BC = $0000  | BC = $0000
; F  = carry flag is preserved
; ---------------------------------------------------------------
; Memory usage in statvars:
; ---------------------------------------------------------------
; $8A3A / $8A89 -  80 bytes - free (or used by z88dk app)
; $8A8A / $8A8C -   3 bytes - JP IntProcStart
; $8A8D / $8AFF - 115 bytes - free (some bytes used by z88dk app)
; $8B00 / $8C00 - 256 bytes - IV table
; $8C01 / $8C4D -  77 bytes - free
; ---------------------------------------------------------------
; See the interrupt routines themselves for
;  further info of memory useage.
