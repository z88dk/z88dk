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
; $Id: gray85.asm,v 1.3 2001-10-31 11:25:11 stefano Exp $
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

	and	@11000000		; Test if our block of memory is
	cp	@11000000		;  within the range addressable
	jr	nz,cleanup		;  by the LCD hardware

	ld	(graybit2),hl		; Save the address of our 2nd Screen

	ld	a,h			; If in range, set up the signal to
	and	@00111111		;  send thrue port 0 to switch to our
	ld	(page2),a		;  2nd screen
;----
	;dec	h			; Set the IV for IM2 mode
	;ld	a,h			;
	;ld	i,a			;
	
	;ld      (hl),IntProcStart&$FF	; Set the IV table
	;inc     hl			;
	;ld      (hl),IntProcStart/256	;
	;ld	d,h			;
	;ld	e,l			;
	;dec	hl			;
	;inc	de			;
	;ld	bc,$0100		;
	;ldir				;
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

;.IntProcStart
;	push	af			;
;	ld	a,(intcount)		; Check if own interrupt has quited
;	bit	7,a			;  correctly, then bit 7 is zero
;	jr	nz,int_fix		; If not zero, fix stack...
;	push	hl			;
;	push	de			;
;	push	bc			;
;	push	iy			;
;	ld	iy,_IY_TABLE		;
;					;
;.cont_interrupt			;
;	in	a,(3)			;
;	bit	1,a			; check that it is a vbl interrupt
;	jr	z,EndInt		;
;					;
;	ld	a,(intcount)		;
;	res	7,(hl)			;
;	cp	2			;
;	jr	z,Disp_2		;
;					;
;.Disp_1				;
;	inc	a			;
;	ld	(intcount),a		;
;	ld	a,(page2)		;
;	out	(0),a			;
;	jr	EndInt			;
;.Disp_2				;
;	ld	a,$3c			;
;	out	(0),a			;
;	sub	a			;
;	ld	(intcount),a		;
;.EndInt				;
;	ld	hl,intcount		; If a 'direct interrupt' occures    
;	set	7,(hl)			;  right after the TIOS-int, then
;					;  we want bit 7 to be set...
;	exx				; Swap to shadow registers.
;	ex	af,af			; So the TIOS swaps back to the
;					;  normal ones... (the ones we saved
;					;  with push/pops)
;	rst	$38			;
;	di				; 'BIG' HOLE HERE... (TIOS does ei...)
;	ex	af,af			;
;	exx				;
;					;
;	ld	hl,intcount		; Interrupt returned correctly, so
;	res	7,(hl)			;  we reset our error-condition...
;	pop	iy			;
;	pop	bc			;
;	pop	de			;
;	pop	hl			;
;	pop	af			;
;	ei				;
;	ret				; Return to program
;					;
;.int_fix				;
;	pop	af			; Pop AF back
;	ex	af,af			; Fix shadowregs back
;	exx				;
;	pop	bc			; Pop the returnpoint of RST $38
;					;  from the stack
;	jr	cont_interrupt		; Continue with interrupt
;.IntProcEnd

.IntProcStart
	push	af			;
	in	a,(3)			;
	bit	1,a			; check that it is a vbl interrupt
	jr	z,EndInt		;
					;
	ld	a,(intcount)		;
	cp	2			;
	jr	z,Disp_2		;
					;
.Disp_1					;
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
.EndInt					;
	pop	af			;
	ei				;
	ret				; Skip standard interrupt
.IntProcEnd

.graybit1 defw VIDEO_MEM
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
