
; Turn off the cassette motor and enable interrupts.

; On some target, e.g. the MSX, two separate routines were provided,
; TAPIOF (to complete a READ operation) and TAPOOF (for WRITE).


    SECTION code_clib


    PUBLIC  bit_tapiof
    PUBLIC  _bit_tapiof

    EXTERN  bit_close_ei

    INCLUDE "classic/games/games.inc"


bit_tapiof:
_bit_tapiof:

IF  __CPU_GBZ80__||__CPU_INTEL__
    ret
ELSE

;------------------ Target specific section --------------------

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

  IF    FORvg5k
    XOR     A
    OUT     ($AF), A                    ; MOTOR OFF
  ENDIF

  IF    FORaquarius
    ex      af, af
    ld      (13312), a                  ; restore border
  ENDIF

  IF    FORzx81
    EXTERN  zx_slow
    call    zx_slow
  ELSE
; ZX Spectrum, SAM, TS2068, etc..
    call    bit_close_ei
  IF    (TAPEIN_ONEBIT_port=$FE)
    EXTERN  __snd_tick
    ld      a, (__snd_tick)             ; Restore border colour
    ONEBITOUT
  ENDIF
  ENDIF

;---------------------------------------------------------------


;	pop hl		; on exit, keep __LOADLEN
;	RET

ENDIF
