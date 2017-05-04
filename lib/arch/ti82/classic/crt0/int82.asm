; Ti82 interrupt loader - by Henk Poley
; Based upon several sources, uses APD_BUF to put the IV-table and interrupt
;-----------------------------------------------------------------------------
; You only need to have an interrupt marked with IntProcStart
;  at the beginning, and IntProcEnd at the end of your interrupt.
; Since CrASH moves your program when executing the TIOS keyhandler,
;  we need to put the interrupt into a safe RAM area, here we use
;  the APD_BUF for that. (you need to enable IM2 yourself)
;
; NEW:
;  - Interrupt won't go 'boom' because of CR_KHAND relocation.
;  - Uses the CrASH protocol for installing interrupts.
;-----------------------------------------------------------------------------

;defc INT_STATE  = $8D72 ; 1   byte  - Interrupt status (0 = no running interrupt)
;defc CURSOR_POS = $800C ; 2   bytes - Cursor Position

	ld	a,(INT_STATE)		; Find the Interrupt State
	or	a			;
	jr	z,OK			; If clear, install interrupt
					;
	ld	hl,$0002		; Display starting second row
	ld	(CURSOR_POS),hl		;
	ld	hl,UnloadStr		; Display the UnloadStr
	call	$8D74			; ROM_CALL(D_ZT_STR)
	defw	$38FA			;
	call	$8D91			; CALL CR_KHAND (Wait for a key)
	jp	cleanup			;  -> quit
					;
UnloadStr:
	defm	"Please disable  "	;
	defm	"the interrupt   "	;
	defm	"that is running."	;
	defb	0
					;
OK:
	im	1			; For safety reasons...
	ld	a,$84			;
	ld	i,a			; IV table will be at $8400-$8500
	ld	bc,$0100		; IV table is 256 bytes long
	ld	h,a			;
	ld	l,c			; HL = $8400
	ld	d,a			;
	ld	e,b			; DE = $8401
	dec	a			;
	dec	a			; A  = $82
	ld      (hl),a			; Set first number of IV table
	ldir				; Copy from HL to DE, BC bytes

	; Now, we DON'T setup a JP IntProcStart, because when CR_KHAND
	;  relocates this code, things will go horribly wrong. So we
	;  just put the whole interrupt (about 92 bytes) into APD_RAM
	
	ld	hl,IntProcStart		;
	ld	d,a			;
	ld	e,a			; DE = $8282
	ld	bc,IntProcEnd-IntProcStart
	ldir				;

; Registers by now:
; ------------------------------------------------------
; A  = $82
; HL = IntProcStart + (IntProcEnd-IntProcStart)
; DE = $8282        + (IntProcEnd-IntProcStart)
; BC = $0000
; F  = destroyed
; ------------------------------------------------------
; Memory usage in APD_BUF:
; ------------------------------------------------------
; $8228 / $8281 -  90 bytes - free
; $8282 / $83FF - 382 bytes - partialy used by interrupt
; $8400 / $8500 - 256 bytes - IV table
; $8501 / $8528 -  40 bytes - free
; ------------------------------------------------------
; See the interrupt routines themselves for
;  further info of memory useage.

