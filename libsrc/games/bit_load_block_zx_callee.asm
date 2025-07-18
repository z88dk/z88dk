;
;      Tape load routine
;
;      int __CALLEE__ bit_load_block_zx_callee(void *addr, size_t len, unsigned char type)
;

;      TODO: the ZX81 loads wrong data when the audio phase is inverted (??)


    PUBLIC  bit_load_block_zx_callee
    PUBLIC  _bit_load_block_zx_callee
    PUBLIC  asm_bit_load_block_zx

    EXTERN  bit_open_di
    EXTERN  bit_close_ei

    EXTERN  __snd_tick

    INCLUDE "games/games.inc"

bit_load_block_zx_callee:
_bit_load_block_zx_callee:

IF  __CPU_GBZ80__||__CPU_INTEL__
asm_bit_load_block_zx:
    ret
ELSE


    pop     hl
    pop     bc
    ld      a, c
    pop     de
    pop     bc
    push    hl

asm_bit_load_block_zx:

; enter : ix = addr
;         de = len
;          a = type


    push    ix
  IF    FORzx81
    EX      AF, AF'
    PUSH    AF
    EX      AF, AF'
  ENDIF

    push    af
  IF    FORzx81
    push    de
    EXTERN  zx_fast
    call    zx_fast
    pop     de
    OUT     ($FF), A                   ;   set output bit high
  ELSE
    call    bit_open_di
  ENDIF
    pop     af


IF SOUND_ONEBIT_port >= 256
    exx
    ld      bc,SOUND_ONEBIT_port
    exx
ENDIF


    push    bc
    pop     ix

    SCF

    INC     D
    EX      AF, AF'

  IF    FORc128
    IN      a,(1)
	and     223                         ; Reset BIT 5 (address 1 in the zero page)
    OUT     (1), A                      ; MOTOR ON
  ENDIF

  IF    FORmsx
    LD      A, $08
    OUT     ($AB), A                    ; MOTOR ON
  ENDIF

  IF    FORsvi
    LD      A, $08
    OUT     ($97), A                    ; MOTOR ON
  ENDIF

  IF    FORmc1000
    LD      A, $0F
    OUT     ($20), A                    ; Set PSG register for data input port
  ENDIF

    DEC     D

    CALL    LD_BYTES

;        LD       A,(__SYSVAR_BORDCR)
;        AND     $38
;        RRCA
;        RRCA
;        RRCA
;        OUT     ($FC),A
;        LD      A,$7F
;        IN      A,($FC)
;        RRA
  IF    FORzx81
    EXTERN  zx_slow
    call    zx_slow
  ELSE
    call    bit_close_ei
  IF    (TAPEIN_ONEBIT_port=$FE)
    ld      a, (__snd_tick)             ; Restore border colour
    ONEBITOUT
  ENDIF
  ENDIF

  IF    FORc128
    IN      a,(1)
	or      32                          ; Set BIT 5 (address 1 in the zero page)
    OUT     (1), A                      ; MOTOR OFF
  ENDIF

  IF    FORmsx
    LD      A, $09
    OUT     ($AB), A                    ; MOTOR OFF
  ENDIF

  IF    FORsvi
    LD      A, $09
    OUT     ($97), A                    ; MOTOR OFF
  ENDIF

  IF    FORzx81
    EX      AF, AF'
    POP     AF
    EX      AF, AF'
  ENDIF
    pop     ix

;		LD      HL,0
;		RET     NC

;		DEC     HL		; Error:  -1
    RET



LD_BYTES:

  IF    FORsam
    ex      (sp), hl
    ex      (sp), hl
    ex      (sp), hl
    ex      (sp), hl
  ENDIF

  ONEBITIN

        ;RRA

    AND     TAPEIN_ONEBIT_mask
        ;AND     $20
        ;OR      $02
    LD      C, A

  IF    FORsam
    ex      (sp), hl
    ex      (sp), hl
    ex      (sp), hl
    ex      (sp), hl
  ENDIF

    CP      A


LD_BREAK:
    RET     NZ

LD_START:
    CALL    LD_EDGE_1
    JR      NC, LD_BREAK

    LD      HL, $0415

LD_WAIT:
    DJNZ    LD_WAIT

    DEC     HL
    LD      A, H
    OR      L
    JR      NZ, LD_WAIT

    CALL    LD_EDGE_2
    JR      NC, LD_BREAK

LD_LEADER:
    LD      B, $9C
    CALL    LD_EDGE_2
    JR      NC, LD_BREAK

    LD      A, $C6
    CP      B
    JR      NC, LD_START

    INC     H
    JR      NZ, LD_LEADER

LD_SYNC:
    LD      B, $C9
    CALL    LD_EDGE_1
    JR      NC, LD_BREAK

    LD      A, B            ; Check if we reached the gap between the leader tone and the data trail
    CP      $D4
    JR      NC, LD_SYNC     ; If the gap is longer than $D4, we can start loading

    CALL    LD_EDGE_1
    RET     NC

    LD      A, C
    XOR     $03
    LD      C, A
    LD      H, $00
    LD      B, $B0
    JR      LD_MARKER

LD_LOOP:
    EX      AF, AF'
    JR      NZ, LD_FLAG

    LD      (IX+$00), L                 ;
    JR      LD_NEXT

LD_FLAG:
    RL      C
    XOR     L
    RET     NZ

    LD      A, C
    RRA
    LD      C, A
    INC     DE
    JR      LD_DEC

LD_NEXT:
    INC     IX

LD_DEC:
    DEC     DE
    EX      AF, AF'
    LD      B, $B2
LD_MARKER:
    LD      L, $01

LD_BYTE:
    CALL    LD_EDGE_2
    RET     NC

    LD      A, $CB
    CP      B
    RL      L
    LD      B, $B0
    JP      NC, LD_BYTE

    LD      A, H
    XOR     L
    LD      H, A
    LD      A, D
    OR      E
    JR      NZ, LD_LOOP

    LD      A, H
    CP      $01
    RET

;--------------------------
; Check signal being loaded
;--------------------------
;
;

LD_EDGE_2:
    CALL    LD_EDGE_1
    RET     NC

LD_EDGE_1:
    LD      A, LDR_DATA_TIMING

;; LD-DELAY
L05E9:
    DEC     A
    JR      NZ, L05E9                   ; to LD-DELAY

    AND     A

;; LD-SAMPLE
L05ED:
    INC     B
    RET     Z

  IF    FORsam
    ex      (sp), hl
    ex      (sp), hl
    ex      (sp), hl
    ex      (sp), hl
  ENDIF

  ONEBITIN

        ;RRA
        ;RET     NC

    XOR     C
    AND     TAPEIN_ONEBIT_mask
    JR      Z, L05ED                    ; to LD-SAMPLE

    LD      A, C
    CPL
    LD      C, A

  IF    FORsam
    ex      (sp), hl
    ex      (sp), hl
    ex      (sp), hl
    ex      (sp), hl
  ENDIF

    AND     $07

  IF    (TAPEIN_ONEBIT_port=$FE)
  IF    FORzx81
    OUT     ($FF), A
  ELSE
    AND     $07
	;OR      $09
    OR      $0A                         ; Changing the output mask we may alter the color of the data being loaded
    OUT     ($FE), A
  ENDIF
  ENDIF
          ;OR      $09
        ;OUT     (BORDER),A

    SCF                                 ; Set Carry Flag
    RET

ENDIF
