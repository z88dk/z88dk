
; Graylib interrupt installer
; Ported by Stefano Bodrato - Mar 2000
;
; original code (portions of gray82.inc and greylib.asm) by:
;
;---------------= Gray82 =--------------
; Author:	Ian Graf
;			(ian_graf@geocities.com)
; Port:		Sam Heald
;			(void.calc.org)
;---------------------------------------------------------------------------
;***** GreyLib version 1.0 (C) 1997 by Bill Nagel & Dines Justesen *********
;---------------------------------------------------------------------------
;
; $Id: graylib83p.asm,v 1.5 2001-06-06 14:01:55 stefano Exp $
;

	XDEF	graybit1
	XDEF	graybit2

defc intcount = $8583

IF (startup=2) | (startup=3)	; MirageOS
	; Quick hack to make things work (I hope)
	ld	hl,IntProcStart	; Load interrupt start addres
	ld	($966F),hl	; Store at custintaddr
	
	; Now set MIRINT to enable custum interrupt (bit 5)
	DEFINE MIRINT = MIRINT + 32
	DEFINE UseMirageInt = UseMirageInt + 1

ELSE	; Other Ti83+ shells

	; Set the IM2 mode vector table to point to the interrupt code...
	ld hl,$8300

	; Set the IV table
	ld	(hl),IntProcStart&$FF
	inc	hl
	ld	(hl),IntProcStart/256
	ld	d,h
	ld	e,l
	dec	hl
	inc	de
	ld	bc,255
	ldir
ENDIF
	xor	a		; Init vars
	ld	(intcount),a
	ld	a,$83		; Point to the new table
	ld	i,a
	im	2
	jp	jump_over	; Jump over the interrupt

;-----------------
; Actual interrupt
;-----------------
.IntProcStart
	push	af
	push	hl
	push	de
	push	bc
		
	in	a,(3)		; check vbl int
	and	@00000010	;
	jr	z,exit_interrupt;
	ld	hl,intcount	; inc counter
	inc	(hl)		;
	ld	a,(hl)		;
	dec	a		; 1
	jr	z,Display_pic1
	dec	a		; 2
	jr	z,Display_pic2
	ld	(hl),0		; reset counter
.exit_interrupt
	in	a,(3)		; check on interrupt status
	rra			;
	ld	a,0		;
	adc	a,9		;
	out	(3),a
	ld	a,$0B
	out	(3),a
	
	pop	bc
	pop	de
	pop	hl
	pop	af
	ei
IF (startup=2) | (startup=3)	; MirageOS
	ret
ELSE				; Other shells
	reti			; Skip standard interrupt
ENDIF

.Display_pic1
	ld	hl,(graybit1)
	jr	DisplayPicture
.Display_pic2
	ld	hl,(graybit2)
	;jr	DisplayPicture
.DisplayPicture
	ld	a,7
; I QUESTION IF THESE TWO LINES ARE NEEDED HERE...
	ex	(sp),hl		; Just like LCDBUSY (38 clk is enough delay)
	ex	(sp),hl
	out	($10),a		; Send 00000111 to LCD : select row number
	ld	a,$80		; Goto the left
.LineLoop
	ld	d,a		; Save currect coloum
	ex	(sp),hl
	ex	(sp),hl
	out	($10),a
	ld	a,$20		; Goto top
	ex	(sp),hl
	ex	(sp),hl
	out	($10),a
	ld	bc,$0C11	; 40 bytes to port 10
.WriteLoop			; Write them
	neg
	neg
	neg
	neg
	outi
	jr	nz,WriteLoop
	ld	a,d
	inc	a
	cp	$C0
	jr	nz,LineLoop
	jr	exit_interrupt

.graybit1	defw	$9340	;plotscreen

;.graybit2	defw	$9872	;saferam1(apdram)
.graybit2	defw	gbuf2

.gbuf2		DEFS	768

.jump_over
