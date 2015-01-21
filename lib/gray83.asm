;                        Ti83 Graylib interrupt
;---------------------------------------------------------------------------
;
; Ported by Stefano Bodrato - Mar 2000
;
; Recoded -because of strange problems- by Henk Poley - July 2001
; Based upon vnGrey, a Venus greyscale library (Ti83).
;
; $Id: gray83.asm,v 1.6 2015-01-21 07:05:00 stefano Exp $
;

defc intcount    = $878A        ; 1 byte needed
	
	INCLUDE "int83.asm"		; Put interrupt loader here
					; HL = $8789
	inc	hl			; We need to intialize variables
	ld	(hl),0			;  by ourself.
					;
	jp	jump_over		; Jump over the interrupt code

;-----------------
; Actual interrupt
;-----------------
IntProcStart:
	push	af			;
	ld	a,(intcount)		; Check if own interrupt has quited
	bit	7,a			;  correctly, then bit 7 is zero
	jr	nz,int_fix		; If not zero, fix stack...
	push	hl			;
	push	de			;
	push	bc			;
	push	iy			;
	ld	iy,_IY_TABLE		;
					;
exit_interrupt:
	in	a,(3)			; check vbl int
	and	@00000010		;
	jr	z,exit_interrupt2	;
	ld	hl,intcount		; int counter
	res	7,(hl)			;
	inc	(hl)			;
	ld	a,(hl)			;
	dec	a			; 1
	jr	z,Display_pic1		;
	dec	a			; 2
	jr	z,Display_pic2		;
	ld	(hl),0			; reset counter
exit_interrupt2:
	ld	hl,intcount		; If a 'direct interrupt' occures    
	set	7,(hl)			;  right after the TIOS-int, then
					;  we want bit 7 to be set...
	exx				; Swap to shadow registers.
	ex	af,af			; So the TIOS swaps back to the
					;  normal ones... (the ones we saved
					;  with push/pops)
	rst	$38			;
	di				; 'BIG' HOLE HERE... (TIOS does ei...)
	ex	af,af			;
	exx				;
					;
	ld	hl,intcount		; Interrupt returned correctly, so
	res	7,(hl)			;  we reset our error-condition...
					;
	in	a,(3)			; check on interrupt status
	rra				;
	ld	a,0			;
	adc	a,9			;
	out	(3),a			;
	ld	a,$0B			;
	out	(3),a			;
					;
	pop	iy			;
	pop	bc			;
	pop	de			;
	pop	hl			;
	pop	af			;
	ei				;
	ret				;

int_fix:
	pop	af			; Pop AF back
	ex	af,af			; Fix shadowregs back
	exx				;
	pop	bc			; Pop the returnpoint of RST $38
					;  from the stack
	jr	exit_interrupt		; Continue with interrupt


Display_pic1:
	ld	hl,(graybit1)		;
	jr	DisplayPicture		;
Display_pic2:
	ld	hl,(graybit2)		;
DisplayPicture:
	ld	a,$80			; fastCopy routine
	out	($10),a			; (Joe Wingbermuehle)
	ld	a,$20			;
	ld	c,a			;
	ld	de,755			;
	add	hl,de			;
fastCopyAgain:
	ld	b,64			;
	inc	c			;
	ld	de,-(12*64)+1		;
	out	($10),a			;
	add	hl,de			;
	ld	de,10			;
fastCopyLoop:
	add	hl,de			;
	inc	hl			;
	inc	hl			;
	inc	de			;
	ld	a,(hl)			;
	out	($11),a			;
	dec	de			;
	djnz	fastCopyLoop		;
	ld	a,c			;
	cp	$2B+1			;
	jr	nz,fastCopyAgain	;
	jr	exit_interrupt2		;
IntProcEnd:

	PUBLIC	graybit1
	PUBLIC	graybit2

graybit1:	defw	plotSScreen
IF DEFINED_DontUseApdRam
graybit2:	defw	gbuf2
gbuf2:		defs	768
ELSE
graybit2:	defw	saveSScreen
ENDIF

jump_over:

; Memory usage in statvars:
; -------------------------------------------
; $858F / $85FF - 113 bytes - free
; $8600 / $8700 - 256 bytes - IV table
; $8701 / $8786 - 134 bytes - free
; $8787 / $8789 -   3 bytes - JP IntProcStart
; $878A         -   1 byte  - intcount        <--
; $878B / $87A2 -  24 bytes - free
; -------------------------------------------
