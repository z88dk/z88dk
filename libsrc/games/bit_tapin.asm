
;Read a byte from cassette
;
;This routine does not check the stop bit (DATAW writes two stop bits).
;So, there is no framing or over-run condition.
;This was done to give the caller enough time to process the byte read before next byte arrives.
;Before using this routine, cassette motor should be turned on.

; On exit: HL = read byte or -1 on error


        SECTION code_clib


        PUBLIC  bit_tapin
        PUBLIC  _bit_tapin

        PUBLIC  bit_tapin_bit
        PUBLIC  _bit_tapin_bit

        EXTERN  bit_tapiof


        EXTERN  __LOWLIM
        EXTERN  __WINWID


        INCLUDE "games/games.inc"


  IF    __CPU_GBZ80__||__CPU_INTEL__
bit_tapin:
_bit_tapin:
bit_tapin_bit:
_bit_tapin_bit:
        ret
  ELSE


bit_tapin:
_bit_tapin:

        LD      A, (__LOWLIM)           ; Minimal length of startbit
        LD      D, A
TAPIN_0:
;  CALL BREAKX			; Set CY if STOP is pressed
;  RET C
;  IN A,(TAPEIN_ONEBIT_port)
        CALL    BREAKX                  ; Set CY if STOP is pressed
        JP      C, TAPIN_ERROR

;  IN A,(PSG_DATAIN)
;  RLCA
;  JR NC,TAPIN_0
        AND     TAPEIN_ONEBIT_mask
        JR      NZ, TAPIN_0
TAPIN_1:
;  CALL BREAKX			; Set CY if STOP is pressed
;  RET C
;  IN A,(TAPEIN_ONEBIT_port)
        CALL    BREAKX                  ; Set CY if STOP is pressed
        JP      C, TAPIN_ERROR

;  IN A,(PSG_DATAIN)
;  RLCA
;  JR C,TAPIN_1
        AND     TAPEIN_ONEBIT_mask
        JR      Z, TAPIN_1

        LD      E, $00
        CALL    TAPIN_PERIOD
TAPIN_2:
        LD      B, C

        CALL    TAPIN_PERIOD
        JP      C, TAPIN_ERROR
  ;RET C
        LD      A, B
        ADD     A, C
        JP      C, TAPIN_2
        CP      D
        JP      C, TAPIN_2
;  LD L,8
        LD      L, 8                    ; <-- on the ZX Spectrum something goes wrong during the first bit 'sync', so we trash one extra bit
TAPIN_BYTE:
        CALL    TAPIN_STARTBIT
        CP      $04
        CCF
        JR      C, TAPIN_ERROR
  ;RET C
        CP      $02
        CCF
        RR      D
        LD      A, C
        RRCA                            ;  A word, usually one byte (8 bits) long, is recorded in little endian order
        CALL    NC, TAPIN_PERIOD_0
        CALL    TAPIN_PERIOD
        DEC     L
        JP      NZ, TAPIN_BYTE

;  CALL BREAKX		; Set CY if BREAK is pressed
;  IN A,(TAPEIN_ONEBIT_port)

;  LD A,D
        LD      H, 0
        LD      L, D
        RET

TAPIN_ERROR:
        call    bit_tapiof
        LD      HL, -1                  ; error code
        RET


TAPIN_STARTBIT:
        LD      A, (__WINWID)           ;  Get the difference between a low-and high-cycle
        LD      B, A
        LD      C, $00

TAPIN_STARTBIT_0:

;  IN A,(PSG_DATAIN)
;  XOR E
;  JP P,_TAPIN_STARTBIT_1
;  LD A,E
;  CPL
;  LD E,A
;  INC C
;  DJNZ _TAPIN_STARTBIT_0
;  LD A,C
;  RET

;  IN A,(PSG_DATAIN)

    IF  FORsam
        ex      (sp), hl
        ex      (sp), hl
        ex      (sp), hl
        ex      (sp), hl
    ENDIF

        IN      A, (TAPEIN_ONEBIT_port)
        XOR     E
        AND     TAPEIN_ONEBIT_mask
        JP      Z, TAPIN_STARTBIT_1
        LD      A, E
        CPL
        LD      E, A

    IF  FORsam
        ex      (sp), hl
        ex      (sp), hl
        ex      (sp), hl
        ex      (sp), hl
    ENDIF

;------------------ Target specific section --------------------
; ZX Spectrum, SAM, TS2068, etc..
    IF  (TAPEIN_ONEBIT_port=$FE)
        AND     $07
	;OR      $09
        OR      $0A                     ; Changing the output mask we may alter the color of the data being loaded
        OUT     ($FE), A
    ENDIF

    IF  FORaquarius
        AND     $07
        OR      $01
        ld      (13312), a
    ENDIF
;------------------ Target specific section --------------------

        INC     C
        DJNZ    TAPIN_STARTBIT_0
        LD      A, C
        RET

TAPIN_STARTBIT_1:
        DJNZ    TAPIN_STARTBIT_0
        LD      A, C
        RET



bit_tapin_bit:
_bit_tapin_bit:

        CALL    BREAKX                  ; Set CY if STOP is pressed
        RET     C
  ;IN A,(TAPEIN_ONEBIT_port)

;  IN A,(PSG_DATAIN)
;  RLCA
        AND     TAPEIN_ONEBIT_mask
        JR      NZ, bit_tapin_bit       ; .. should it be JR Z, ?
        LD      E, $00
        CALL    TAPIN_PERIOD_0
        JP      TAPIN_PERIOD_1


; Used by the routine at TAPIN.
TAPIN_PERIOD:
        CALL    BREAKX                  ; Set CY if STOP is pressed
        RET     C
  ;IN A,(TAPEIN_ONEBIT_port)

TAPIN_PERIOD_0:
        LD      C, $00

;TAPIN_PERIOD_1:
;  INC C
;  JR Z,TAPIN_PERIOD_OVERFLOW
;  IN A,(PSG_DATAIN)
;  XOR E
;  JP P,TAPIN_PERIOD_1

TAPIN_PERIOD_1:
        INC     C
        JR      Z, TAPIN_PERIOD_OVERFLOW

    IF  FORsam
        ex      (sp), hl
        ex      (sp), hl
        ex      (sp), hl
        ex      (sp), hl
    ENDIF

        IN      A, (TAPEIN_ONEBIT_port)

;  IN A,(PSG_DATAIN)
        XOR     E
        AND     TAPEIN_ONEBIT_mask
        JP      Z, TAPIN_PERIOD_1
        LD      A, E
        CPL
        LD      E, A

    IF  FORsam
        ex      (sp), hl
        ex      (sp), hl
        ex      (sp), hl
        ex      (sp), hl
    ENDIF

;------------------ Target specific section --------------------
; ZX Spectrum, SAM, TS2068, etc..
    IF  (TAPEIN_ONEBIT_port=$FE)
        AND     $07
        OR      $09
        OUT     ($FE), A
    ENDIF

    IF  FORaquarius
        AND     $07
        OR      $02
        ld      (13312), a
    ENDIF
;---------------------------------------------------------------

        RET

TAPIN_PERIOD_OVERFLOW:
        DEC     C
        RET

; Here we need to do 2 things together,
; get the current status from the TAPE port and set CY if BREAK was pressed
BREAKX:
    IF  (TAPEIN_ONEBIT_port=$FE)
        LD      A, $7F                  ; scan only the right keyboard portion
        IN      A, ($FE)
        BIT     0, A
        SCF
        RET     Z
        CCF
        RET

    ELSE
        IN      A, (TAPEIN_ONEBIT_port)
        and     a                       ; Reset CY, in case break detection is not supported
        RET
    ENDIF


  ENDIF
