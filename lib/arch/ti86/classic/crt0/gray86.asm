
; Graylib interrupt installer
; Ported for the Z88DK and modified for the TI86 by Stefano Bodrato - May 2000
;
; original code (graydraw.asm) by:
;
;------------------------------------------------------------
; Date:     Sun, 5 May 1996 12:44:17 -0400 (EDT)
; From:     Jingyang Xu  [br00416@bingsuns.cc.binghamton.edu]
; Subject:  LZ: Graydraw source!
;------------------------------------------------------------
;
; $Id: gray86.asm,v 1.5 2015-01-21 07:05:00 stefano Exp $
;

	PUBLIC	graybit1
	PUBLIC	graybit2
	PUBLIC	page2

	ld	hl,$f500		; ld hl,($d297)   ;get end of VAT

	;dec hl
	;dec hl	 			; make sure we're clear it..

	ld	a,h			; now we need to get the position of
	sub	5			; the nearest screen boundary
	ld	h,a
	ld	l,0

	ld	(graybit2),hl		; Save the address of our 2nd Screen

	ld	a,h			; save the byte to send to port 0
	and	@00111111		; to switch to our 2nd screen
	ld	(page2),a
	
	dec	h			; Set the IV for IM2 mode
	ld	a,h
	ld	i,a

	ld	(hl),IntProcStart&$FF	; Set the IV table
	inc	hl
	ld	(hl),IntProcStart/256
	ld	d,h
	ld	e,l
	dec	hl
	inc	de
	ld	bc,255
	ldir


	xor	a			; Init counter
	ld	(intcount),a
	jp	jump_over

IntProcStart:
	push	af
	in	a,(3)
	bit	1,a			; check that it is a vbl interrupt
	jr	z,EndInt

	ld	a,(intcount)
	cp	2
	jr	z,Disp_2

Disp_1:
	inc	a
	ld	(intcount),a
	ld	a,(page2)
	out	(0),a
	jr	EndInt
Disp_2:
	ld	a,$3c
	out	(0),a
	xor	a
	ld	(intcount),a
EndInt:
	;in a,(3)			;this stuff must be done or calc crashes
	;rra				;mysterious stuff from the ROM
	;ld a,0
	;adc a,9
	;out (3),a
	;ld a,$0B
	;out (3),a

	pop	af
	ei
	reti
	;jp $38
IntProcEnd:

graybit1: defw $fc00	;GRAPH_MEM
graybit2: defw 0
page2:    defb 0
intcount: defb 0

jump_over:

