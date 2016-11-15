;
; 	ANSI Video handling for the MicroBEE
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - 2016
;
;
;	$Id: f_ansi_cls.asm,v 1.1 2016-11-15 08:11:11 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_cls

	
.vdutab		; 80x25 - Peter Broughton
;	defb	$6b,$50,$5b,$37,$1b,$05,$19,$1a,$48,$0a,$2a,$0a,$20,0,0,0
	defb	$6b,$50,$59,$37,$1b,$05,$19,$1b,$48,$0a,$2a,$0a,$20,0,0,0


.ansi_cls
	LD	HL,vdutab
	LD  C,0
	LD	B,16
.vdloop
	LD	A,C
	OUT	($0C),A
	LD	A,(HL)
	OUT	($0D),A
	INC	HL
	INC C
	DJNZ	vdloop
	
	ld	a,64
	out (8),a
	ld	hl,$F800
	;ld  d,7*16
	ld  d,15
	call setattr
	xor a
	out (8),a

	ld  d,' '
	ld	hl,$F000
.setattr
	ld	bc,80*25
.clean
	inc	hl
	ld	a,d
	ld	(hl),a
	dec	bc
	ld	a,b
	or	c
	jr	nz,clean
	
	ret
