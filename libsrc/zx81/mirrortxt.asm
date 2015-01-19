;
;       ZX81 libraries
;
;--------------------------------------------------------------
; This code comes from the FidoNET Sinclair newsgroup
;--------------------------------------------------------------
;
;       $Id: mirrortxt.asm,v 1.2 2015-01-19 01:33:26 pauloscustodio Exp $
;
;----------------------------------------------------------------
;
; mirrortxt() - mirror text display
;
;----------------------------------------------------------------

        PUBLIC    mirrortxt

mirrortxt:
	
	LD HL,(400CH) ; Puts the adress of the displayfile in HL
	LD DE,0010H   ; This is the middle of the screen
	ADD HL,DE     ; Add to displayfile
	LD D,H        ; leave result in DE
	LD E,L        ;
	INC DE        ; counting up
	LD B,16H      ; B as counter 22 lines
.MIR1	LD A,(HL)     ; Character in accumulator
	CP 76H        ; look for end line
	JR Z,MIR2     ; If b not 0 goto 409E
	EX DE,HL      ; temporary storage
	LD C,(HL)     ;
	LD (HL),A     ; Print to Dfile
	EX DE,HL      ; get value back again
	LD (HL),C     ; print to Dfile
	DEC HL        ; counting down
	INC DE        ;
	JR MIR1       ; Get next character
.MIR2	LD DE,0031H   ; Go to middle of next line
	ADD HL,DE     ;
	LD D,H        ;
	LD E,L        ;
	INC DE        ;
	DJNZ MIR1     ; until screen full repeat routine
	RET
