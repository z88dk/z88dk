
; Graylib interrupt installer
; Ported and heavily modified by Stefano Bodrato - Mar 2000
;
; original code (graydraw.asm) by:
;
;------------------------------------------------------------
; Date:     Sun, 5 May 1996 12:44:17 -0400 (EDT)
; From:     Jingyang Xu  [br00416@bingsuns.cc.binghamton.edu]
; Subject:  LZ: Graydraw source!
;------------------------------------------------------------
;
; $Id: gray85.asm,v 1.1 2001-07-16 13:27:49 dom Exp $
;


	XDEF	graybit1
	XDEF	graybit2

defc	intcount = $8980

	ld	hl,($8be5)		; Get end of VAT
	dec	hl			; Make sure we're clear it..
	dec	hl			;
	
	ld	a,h			; Now we need to get the position of
	sub	4			;  the nearest screen boundary
	ld	h,a			;
	ld	l,0			;
	push	hl			;

	ld	de,($8be1)		; Tests if there is a space for the 1K
	or	a			;  needed for the 2nd screen
	sbc	hl,de			;
	pop	hl			;
	jr	c,cleanup		; If not, stop the program...

	ld	(graybit2),hl		;  save the address of our 2nd Screen

	and	@11000000		; Test if our block of memory is
	cp	@11000000		;  within the range addressable
	jr	nz,cleanup		;  by the LCD hardware

	ld	a,h			; If in range, set up the signal to
	and	@00111111		;  send thrue port 0 to switch to our
	ld	(page2),a		;  2nd screen

	dec	h			; Set the IV for IM2 mode
	ld	a,h			;
	ld	i,a			;
	
	ld      (hl),IntProcStart&$FF	; Set the IV table
	inc     hl			;
	ld      (hl),IntProcStart/256	;
	ld	d,h			;
	ld	e,l			;
	dec	hl			;
	inc	de			;
	ld	bc,$0100		;
	ldir				;

	xor	a			; Init counter
	ld	(intcount),a		;
	jp	jump_over		; Jump over the interrupt code

.IntProcStart
	push	af			;
	in	a,(3)			;
	bit	1,a			; check that it is a vbl interrupt
	jr	z,EndInt		;

	ld	a,(intcount)		;
	cp	2			;
	jr	z,Disp_2		;

.Disp_1
	inc	a			;
	ld	(intcount),a		;
	ld	a,(page2)		;
	out	(0),a			;
	jr	EndInt			;
.Disp_2
	ld	a,$3c			;
	out	(0),a			;
	sub	a			;
	ld	(intcount),a		;
.EndInt
	pop	af			;
	ei				;
	reti				; Skip standard interrupt
	;jp	$38	; Jump to standard interrupt
.IntProcEnd

.graybit1 defw $fc00			;GRAPH_MEM
.graybit2 defw 0
.page2    defb 0

.jump_over
;	ld	hl,(graybit2)		; Whipe the 2nd screen clean
;	ld	d,h
;	ld	e,l
;	inc	de
;	ld	(hl),0
;	ld	bc,1023
;	ldir
