;
;       MicroBEE pseudo graphics routines
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - 2016
;
;
;       $Id: clg.asm,v 1.1 2016-11-04 15:44:58 stefano Exp $
;

			SECTION code_clib
			PUBLIC  clg
			EXTERN  cleargraphics
			

;.vdutab		; 64*16
;	defb	107,64,81,55,18,9,16,17,$48,$0F,$2F,$0F,0,0,0,0  
	
;.vdutab		; 40x24
;	defb	$35,40,$2D,$24,$1b,$05,$19,$1a,$48,$0a,$2a,$0a,$20,0,0,0

;.vdutab		; 80x24
;	defb	$6b,80,$58,$37,$1b,$05,$18,$1a,$48,$0a,$2a,$0a,$20,0,0,0

;PROGRAM TO FORMAT SCREEN TO 80*25 USING 13.5 Mhz CLOCK
;	DEFW	0506BH
;	DEFW	03757H
;	DEFW	0051BH
;	DEFW	01A19H
;	DEFW	00A48H
;	DEFW	00A60H
;	DEFW	00020H
;	DEFW	00000H

;PROGRAM TO FORMAT SCREEN TO 64*16 USING 13.5 Mhz CLOCK
;	DEFW	0406BH
;	DEFW	03751H
;	DEFW	00912H
;	DEFW	01110H
;	DEFW	00F48H
;	DEFW	00F6FH
;	DEFW	00000H
;	DEFW	00000H
	
;defc basic_rom_lores = 08027h

.clg
	
	jp cleargraphics

;	LD	HL,vdutab+16
;	LD	B,16
;.vdloop
;	LD	A,B
;	DEC	A
;	OUT	($0C),A
;	LD	A,(HL)
;	OUT	($0D),A
;	DEC	HL
;	DJNZ	vdloop

