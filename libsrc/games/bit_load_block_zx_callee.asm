;
;      Tape load routine
;
;      int __CALLEE__ bit_load_block_zx_callee(void *addr, size_t len, unsigned char type)
;


        PUBLIC  bit_load_block_zx_callee
        PUBLIC  _bit_load_block_zx_callee
        PUBLIC  asm_bit_load_block_zx

        INCLUDE "games/games.inc"

bit_load_block_zx_callee:
_bit_load_block_zx_callee:

  IF    __CPU_GBZ80__||__CPU_INTEL__
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

        push    bc
        pop     ix

        SCF

        INC     D
        EX      AF, AF'

    IF  FORmsx
        LD      A, $08
        OUT     ($AB), A                ; MOTOR ON
    ENDIF

    IF  FORsvi
        LD      A, $08
        OUT     ($97), A                ; MOTOR ON
    ENDIF

    IF  FORmc1000
        LD      A, $0F
        OUT     ($20), A                ; Set PSG register for data input port
    ENDIF

        DEC     D
        DI                              ; Disable Interrupts

;        LD      A,$0F
;        OUT     ($FC),A

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
        EI

    IF  FORmsx
        LD      A, $09
        OUT     ($AB), A                ; MOTOR OFF
    ENDIF

    IF  FORsvi
        LD      A, $09
        OUT     ($97), A                ; MOTOR OFF
    ENDIF

        pop     ix

;		LD      HL,0
;		RET     NC

;		DEC     HL		; Error:  -1
        RET



LD_BYTES:
        IN      A, (TAPEIN_ONEBIT_port)
        ;RRA

        AND     TAPEIN_ONEBIT_mask
		;AND     $20
        ;OR      $02
        LD      C, A
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

        LD      A, B
        CP      $D4
        JR      NC, LD_SYNC

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

        LD      (IX+$00), L             ;
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
L05E9:  DEC     A
        JR      NZ, L05E9               ; to LD-DELAY

        AND     A

;; LD-SAMPLE
L05ED:  INC     B
        RET     Z

        ;LD      A,$7F
        ;RRA
        IN      A, (TAPEIN_ONEBIT_port)
;        RET     NC

        XOR     C
        AND     TAPEIN_ONEBIT_mask
        JR      Z, L05ED                ; to LD-SAMPLE

        LD      A, C
        CPL
        LD      C, A
        AND     $07
        ;OR      $09
        ;OUT     (BORDER),A

        SCF                             ; Set Carry Flag
        RET

  ENDIF
