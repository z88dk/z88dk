
; Turn off the cassette motor and enable interrupts.

; On some target, e.g. the MSX, two separate routines were provided,
; TAPIOF (to complete a READ operation) and TAPOOF (for WRITE).


        SECTION code_clib


        PUBLIC  bit_tapiof
        PUBLIC  _bit_tapiof

        EXTERN  bit_close_ei

        INCLUDE "games/games.inc"


bit_tapiof:
_bit_tapiof:

  IF    __CPU_GBZ80__||__CPU_INTEL__
        ret
  ELSE

;------------------ Target specific section --------------------
    IF  FORmsx
        LD      A, $09
        OUT     ($AB), A                ; MOTOR OFF
    ENDIF

    IF  FORsvi
        LD      A, $09
        OUT     ($97), A                ; MOTOR OFF
    ENDIF

    IF  FORvg5k
        XOR     A
        OUT     ($AF), A                ; MOTOR OFF
    ENDIF

; ZX Spectrum, SAM, TS2068, etc..
    IF  (TAPEIN_ONEBIT_port=$FE)
        EXTERN  __snd_tick
        LD      A, (__snd_tick)
        out     ($FE), a
    ENDIF

    IF  FORaquarius
        ex      af, af
        ld      (13312), a              ; restore border
    ENDIF
;---------------------------------------------------------------

        jp      bit_close_ei

;	pop hl		; on exit, keep __LOADLEN
;	RET

  ENDIF
