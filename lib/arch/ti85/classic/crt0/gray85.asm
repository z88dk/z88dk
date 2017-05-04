; Graylib interrupt installer
; Ported and heavily modified by Stefano Bodrato - Mar 2000
; Lateron more modified by Henk Poley - Sep 2001
;
; original code (graydraw.asm) by:
;
;------------------------------------------------------------
; Date:     Sun, 5 May 1996 12:44:17 -0400 (EDT)
; From:     Jingyang Xu  [br00416@bingsuns.cc.binghamton.edu]
; Subject:  LZ: Graydraw source!
;------------------------------------------------------------
;
; $Id: gray85.asm,v 1.6 2015-01-21 07:05:00 stefano Exp $
;

	PUBLIC	graybit1
	PUBLIC	graybit2

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

	and	@11000000		; Test if our block of memory is
	cp	@11000000		;  within the range addressable
	jr	nz,cleanup		;  by the LCD hardware

	ld	(graybit2),hl		; Save the address of our 2nd Screen

	ld	a,h			; If in range, set up the signal to
	and	@00111111		;  send thrue port 0 to switch to our
	ld	(page2),a		;  2nd screen
;----
	im	1			;
	ld	a,$87			; locate vector table at $8700-$8800
	ld	i,a			;
	ld	bc,$0100		; vector table is 256 bytes 
	ld	h,a			;
	ld	l,c			; HL = $8700
	ld	d,a			;
	ld	e,b			; DE = $8801
	inc	a			; A  = $88
	ld	(hl),a			; interrupt "program" located at 8888h
	ldir				;
					;
	ld	l,a			; HL = $8787
	ld	(hl),$C3		; Put a JP IntProcStart at $8787
	ld	de,IntProcStart		; (Done this way for relocatable code...)
	inc	hl			;
	ld	(hl),e			;
	inc	hl			;
	ld	(hl),d			;
;----
	xor	a			; Init counter
	ld	(intcount),a		;
	im	2			; Enable int
	jp	jump_over		; Jump over the interrupt code

IntProcStart:
	push	af			;
	in	a,(3)			;
	bit	1,a			; check that it is a vbl interrupt
	jr	z,EndInt		;
					;
	ld	a,(intcount)		;
	cp	2			;
	jr	z,Disp_2		;
					;
Disp_1:
	inc	a			;
	ld	(intcount),a		;
	ld	a,(page2)		;
	out	(0),a			;
	jr	EndInt			;
Disp_2:
	ld	a,$3c			;
	out	(0),a			;
	sub	a			;
	ld	(intcount),a		;
EndInt:
	pop	af			;
	ei				;
	ret				; Skip standard interrupt
IntProcEnd:

graybit1: defw VIDEO_MEM
graybit2: defw 0
page2:    defb 0

jump_over:
