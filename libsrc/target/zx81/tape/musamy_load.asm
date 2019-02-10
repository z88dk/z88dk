;
;      Musamy Load
;
;      Internal routine for Musamy style turbo tape
;      Load (L=0) and verify (L=0x40), speed auto-calibration
;
;
;	$Id: musamy_load.asm,v 1.5 2015-01-19 01:33:26 pauloscustodio Exp $
;


PUBLIC musamy_load



L00D5:	CCF
L00D6:	EXX
		RL E
		OUT (0FFh),A 	;   set output bit high
		JR NC,L0113
		SET 1,L
		JR L014A



L00FB:	BIT 3,L  ; 0000?000 ; leader pulses mode ?
		JR NZ,L0132

		LD A,C
		EXX
		LD C,A
		ADC E
		RRA
		LD E,A
		AND A
		RRA
		LD B,A
		AND A
		RRA
		ADC B
		INC A
		INC B
		LD C,A
		ADD B
		LD D,A
		EXX


L0111:	LD E,01h

L0113:	LD C,03h
		RES 1,L     ; 000000X0
		JR L014C



L0119:	LD A,L
		AND 12h		;00010010
		JR NZ,L00FB

L011E:	LD A,C
		EXX
		CP B
		JR C,L00D6 ;  exx...
		CP C
		JR C,L00D5 ;  ccf, exx ...
		EXX
		DEC E
		ld hl,0
		JR Z,FINISH ;  load or verify successful
LOADERR:
		inc hl
		;RST 08h		; ERROR 'F'
		;	DEFB 0Eh	; 'Invalid Program Name' (probably due to noise in the LOAD phase)
FINISH:

		pop af ; balance stack
		pop af ; balance stack

		ret
;			RST 08h		; ERROR 'E'
;				DEFB 0Dh	; Load or Verify succesful

L012C:	CP 0Ah		; A <- just loaded with H
		JR C,L0134


; - ENTRY for LOAD
musamy_load:
;		LD H,0Ch ; TIMEOUT
		LD H,02h ; TIMEOUT

L0132:	RES 3,L  ; 0000X000 ; init leader pulses mode 

L0134:	SET 4,L  ; 000X0000
		LD A,39h
		PUSH AF

L0139:	LD E,A		; my byte
L013A:	LD B,A
L013B:	IN A,(0FEh)	; read tape + key row + set output bit low
		RLA
		JR C,L00E7 ; if bit 7 is set..
		DJNZ L013B
		DEC E
		JR NZ,L013A
		DEC H
		JR NZ,L0139
		
		pop hl
		pop hl
		ld hl,3
		JR FINISH
;L0148:	RST 08h		; ERROR
;			DEFB 1Ch	; 'T'


; 
L00E1:	RES 3,L  ; 0000X000 ; init leader pulses mode 
		RES 4,L  ; 000X0000
		JR L0111

L00E7:	POP AF
		BIT 3,L  ; 0000?000 ; leader pulses mode ? 
		JR NZ,L00E1

		LD D,10h	; leader pulse count
		LD C,03h
		JR L014C



L00F4:	DEC D
		JR NZ,L015A
		SET 3,L  ; 0000X000 ; leader pulses done
		JR L015A ;(15a)

L014A:	LD C,09h

L014C:	INC C
		IN A,(0FEh)	; read tape + key row + set output bit low
		RLA
		JR C,L014C ; loop while bit 7 is set..
		BIT 1,L  ; 000000?0
		JR NZ,L0169 ; JP if BYTE READY
		BIT 4,L  ; 000X0000
		JR NZ,L00F4

L015A:	LD B,64h  ; NEVER CHANGE THIS VALUE !
;--L015B:   LD H,H  ---> from the 'LOAD' loop
L015C:	INC C
		IN A,(0FEh)	; read tape + key row + set output bit low
		RLA
		JR C,L0119 ; jp if bit 7 is set
		DJNZ L015C  ; ..loop
		LD A,H
		JR L012C




L0169:	EXX
		POP HL
		POP BC
		LD A,B
		OR C
		LD A,E		; A = byte
		JR NZ,L017B	; 

		POP HL
		NOP
		LD C,(HL)
		INC HL
		LD B,(HL)
		INC HL
		LD E,(HL)
		INC HL
		LD D,(HL)
		EX DE,HL

L017B:	LD E,A		; my byte
		LD A,(HL)
		EXX
		BIT 6,L		; 0X000000  Verify mode flag
		JR Z,L0185

		; VERIFY MODE
		CP E
		JR NZ,L018F

L0185:	; LOAD MODE
		LD A,E
		EXX
		LD (HL),A	; My byte

L0188:	INC HL
		DEC BC
		PUSH BC
		PUSH HL
		EXX
		JR L015A+1 ; -- to L015B


L018F:	EXX
		LD A,H
		CP 40h
		JR NZ,V_ERR
		LD A,L
		CP 40h		; 0X000000  Verify mode flag
		JR C,L0188

V_ERR:	; VERIFY ERROR
		ld hl,2
		push hl	; balance stack
		JP FINISH

