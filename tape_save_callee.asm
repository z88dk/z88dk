;
;      Tape save routine
;
;      Stefano, 2022
;
;      int  tape_save(char *name, size_t loadstart, void *start, void *exec, size_t len);
;

PUBLIC tape_save_callee
PUBLIC _tape_save_callee
PUBLIC asm_tape_save

EXTERN	msxbios

IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
        INCLUDE "target/svi/def/svibasic.def"
ENDIF



.tape_save_callee
._tape_save_callee

  POP AF	; ret_addr
  POP DE	; len
  POP BC	; exec
  POP HL	; start
  EXX
  POP DE	; loadstart
  POP HL	; name

  PUSH AF
  
.asm_tape_save

  PUSH IX

  PUSH DE
  LD A,$D0			; BYTE block type header (long leading tone)
  CALL SEND_CAS_FNAME
  POP DE

  XOR A				; short leading tone
  CALL CWRTON		; start tape for writing

  EX DE,HL
  PUSH HL
  CALL CASOUT_HL	; declared M/C starting address

  EXX

  EX (SP),HL
  ADD HL,DE
  CALL CASOUT_HL	; declared M/C ending address

  LD H,B
  LD L,C
  CALL CASOUT_HL	; declared M/C exec entry
  
  POP HL			; real starting address
  PUSH HL
  ADD HL,DE			; real ending address
  POP DE
  EX DE,HL

BSAVE_LOOP:
  LD A,(HL)
  CALL CASOUT		; send byte to tape
  RST DCOMPR		; Compare HL with DE.
  JR NC,BSAVE_END
  INC HL
  JR BSAVE_LOOP
BSAVE_END:
  ; Stop tape writing
	ld ix,TAPOOF
	call msxbios

  POP IX
  RET




SEND_CAS_FNAME:
  CALL CWRTON		; start tape for writing
  LD B,10
SEND_CAS_TYPE:
  CALL CASOUT		; send 10 type bytes to tape
  DJNZ SEND_CAS_TYPE
  LD B,6
SEND_CAS_NAME:
  LD A,(HL)
  AND A			; check for string termination
  JP NZ,NM_CONT
  LD A,' '
  JP NM_END
NM_CONT:
  INC HL
NM_END:
  CALL CASOUT
  DJNZ SEND_CAS_NAME

IF FORsvi
  LD A,(SCRMOD)
  CALL CASOUT
ENDIF

  ; Stop tape writing
	ld ix,TAPOOF
	call msxbios
  RET


CASOUT_HL:
  LD A,L
  CALL CASOUT
  LD A,H
  JP CASOUT

CASOUT:
  PUSH HL
  PUSH DE
  PUSH BC
  PUSH AF
	ld ix,TAPOUT
	call msxbios
CWRTON_RET:
  POP AF
  POP BC
  POP DE
  POP HL
  RET

CWRTON:
  PUSH HL
  PUSH DE
  PUSH BC
  PUSH AF
	ld ix,TAPOON
	call msxbios
  JR CWRTON_RET
