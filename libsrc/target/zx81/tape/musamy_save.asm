;
;      ZX81 Tape save routine
;
;
;      Musamy Save
;
;      Internal routine for Musamy style turbo tape
;      Save data !  ...set custom speed in (SAVE_SPEED+1)
;
;
;	$Id: musamy_save.asm,v 1.4 2015-01-19 01:33:26 pauloscustodio Exp $
;
;
; speed extimations:
; 3  = 4800 bps
; 9  = 3600 bps
; 20 = 2400 bps
; 40 = 1200 bps
;


PUBLIC musamy_save

PUBLIC SAVE_SPEED


musamy_save:


; Leading pause
		LD D,5
SILNC:	LD BC,0FF00h
DLOOP:	DEC BC
		LD A,B
		OR C
		JR NZ,DLOOP
		DEC D
		JR NZ,SILNC

; Begin
		LD L,06h	; @00000110
LEADER:	LD C,11h	; Leading pulses count

SLOOP:	DEC C
		JR NZ,L0264

		BIT 3,L		; @0000?000   are we in the last phase ?
		JR NZ,RETOK ; if so, return

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

RETOK:	ld	hl,0
		ret

L0214:	LD B,0Eh
DLY1:	DJNZ DLY1
		LD A,D
		RLA
		RLA
		LD B,A
DLY2:	DJNZ DLY2
		SCF
		JR SLOOP


L0222:	CCF

L0223:	RL E
		JR NZ,L0229
		INC L		; update status flags: 00000110, 00000111...  then forced to 00001010
		LD C,L

L0229:	RL L
L022B:	OUT (0FFh),A  ; set output bit high

SAVE_SPEED:
		LD A,20

L0230:	LD D,A
		LD B,D
DLY3:	DJNZ DLY3
		LD B,06h
DLY4:	DJNZ DLY4 ;
		IN A,(0FEh)	; read tape + key row + set output bit low
		XOR A
		BIT 1,L		; @000000?0
		JR NZ,L0214 ; 
		BIT 0,L		; @0000000?	; 
		JR Z,L024D  ; jp if in the leader pulses phase (begin or end)
		LD L,A
		LD B,04h
DLY5:	DJNZ DLY5
		LD B,D
DLY6:	DJNZ DLY6
		JR L0223

L024D:	LD L,A
		LD B,08h
DLY7:	DJNZ DLY7
		LD A,D
		RLA
		LD B,A
DLY8:	DJNZ DLY8
		LD A,7Fh
		IN A,(0FEh)	; read tape + key row + set output bit low
		RRA
		JR C,L0222

cleansp:
		pop hl
		ld a,h
		or l
		jr nz, cleansp
		dec hl	; Exit with error code '-1'
		ret

TRAIL:	LD L,0Ah	; set flags status:  @00001010
		JR LEADER

L0264:	LD B,0Ch
DLY9:	DJNZ DLY9
		JR L022B

NEXT_BLOCK:
		POP HL
		LD A,H
		AND A
		JR Z,TRAIL
		PUSH HL
		JR L020C
