;                       TI83+SE Graylib interrupt
;---------------------------------------------------------------------------
;
; Ported by Stefano Bodrato - Mar 2000
;
; original code (portions of gray82.inc	and greylib.asm) by:
;
;---------------= Gray82 =--------------
; Author:	   Ian Graf
;			   (ian_graf@geocities.com)
; Port:		 Sam Heacp
;			(void.calc.org)
;---------------------------------------------------------------------------
;***** GreyLib version 1.0 (C) 1997 by Bill Nagel & Dines Justesen *********
;---------------------------------------------------------------------------
;
; $Id: gray83pSE.asm,v 1.6 2015-01-21 07:05:00 stefano Exp $
;

defc LCD_BUSY_QUICK  = $000B		; Faster entry then BCALLing
defc LCDBusy         = LCD_BUSY_QUICK	;

	INCLUDE "int83p.asm"		; Put interrupt loader here
IF TI83PLUSAPP
					; Statvars is already zeroed
ELSE
					; HL = $8A8C
	inc	hl			; We need to intialize variables
	ld	(hl),0			;  by ourself.
ENDIF
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
					;
int_fix:
	pop	af			; Pop AF back
	ex	af,af			; Fix shadowregs back
	exx				;
	pop	bc			; Pop the returnpoint of RST $38
					;  from the stack
	jr	exit_interrupt		; Continue with interrupt
					;
Display_pic1:
	ld	hl,(graybit1)		;
	jr	DisplayPicture		;
Display_pic2:
	ld	hl,(graybit2)		;
DisplayPicture:
	ld	a,7			;
	call	LCDBusy			;
	out	($10),a			; Select row number
					;  
	ld	a,$80			; Goto the left
LineLoop:
	ld	d,a			; Save currect coloum
	call	LCDBusy			;
	out	($10),a			;
	ld	a,$20			; Goto top
	call	LCDBusy			;
	out	($10),a			;
	ld	bc,$0C11		; 40 bytes to port 10
WriteLoop:				; Write them
	neg				;
	neg				;
	neg				;
	neg				;
	outi				;
	jr	nz,WriteLoop		;
	ld	a,d			;
	inc	a			;
	cp	$C0			;
	jr	nz,LineLoop		;
	jr	exit_interrupt		;
IntProcEnd:

IF !TI83PLUSAPP
	PUBLIC	graybit1
	PUBLIC	graybit2
	
defc intcount = $8A8D			; 1 byte needed

graybit1:	defw	plotSScreen
graybit2:	defw	appBackUpScreen
ENDIF

jump_over:
