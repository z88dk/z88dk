;
;      Musamy Save
;
;      Internal routine for Musamy style turbo tape
;      Save data !  ...set custom speed in (SAVE_SPEED+1)
;
; speed extimations:
; 3  = 4800 bps
; 9  = 3600 bps
; 20 = 2400 bps
; 40 = 1200 bps
;


XLIB musamy_save

XDEF SAVE_SPEED


LIB zx_fast
LIB zx_slow

musamy_save:


		call zx_fast


; Leading pause
		LD D,5
SILNC:	LD BC,FF00h
DLOOP:	DEC BC
		LD A,B
		OR C
		JR NZ,DLOOP
		DEC D
		JR NZ,SILNC

; Leader tone
		LD L,06h	; @00000110
LEADER:	LD C,11h

L01EE:	DEC C
		JR NZ,L0264

		BIT 3,L		; @0000?000
		JR NZ,RETURN ; set ? - RET !

		BIT 2,L		; @00000?00
		JR Z,NO_GAP

		LD BC,0271h ; 625
GAP:	DEC BC
		LD A,B
		OR C
		JR NZ,GAP

NO_GAP:	POP HL
		LD E,(HL)	; My byte

		POP BC
		LD A,B
		OR C
		JR Z,NEXT_BLOCK

		INC HL
		DEC BC

		PUSH BC
		PUSH HL

L020C:	SCF
		LD L,00h
		JR L0223

RETURN:	;RET
		call	zx_slow
		ld	hl,0
		ret

L0214:	LD B,0Eh
L0216:	DJNZ L0216 ;
		LD A,D
		RLA
		RLA
		LD B,A
L021C:	DJNZ L021C ;
		SCF
		JR L01EE


L0222:	CCF

L0223:	RL E
		JR NZ,L0229
		INC L		; update status flags: 00000110, 00000111, 00001000.
		LD C,L

L0229:	RL L
L022B:	OUT (FFh),A  ; set output bit high

SAVE_SPEED:
		LD A,20

L0230:	LD D,A
		LD B,D
L0232:	DJNZ L0232 ;
		LD B,06h
L0236:	DJNZ L0236 ;
		IN A,(FEh)	; read tape + key row + set output bit low
		XOR A
		BIT 1,L
		JR NZ,L0214
		BIT 0,L
		JR Z,L024D
		LD L,A
		LD B,04h
L0246:	DJNZ L0246 ;
		LD B,D
L0249:	DJNZ L0249 ;
		JR L0223

L024D:	LD L,A
		LD B,08h
L0250:	DJNZ L0250 ;
		LD A,D
		RLA
		LD B,A
L0255:	DJNZ L0255 ;
		LD A,7Fh
		IN A,(FEh)	; read tape + key row + set output bit low
		RRA
		JR C,L0222

cleansp:
		pop hl
		ld a,h
		or l
		jr nz, cleansp
		dec hl	; Exit with error code '-1'
		ret

L0260:	LD L,0Ah
		JR LEADER

L0264:	LD B,0Ch
L0266:	DJNZ L0266 ;
		JR L022B

NEXT_BLOCK:
		POP HL
		LD A,H
		AND A
		JR Z,L0260
		PUSH HL
		JR L020C
