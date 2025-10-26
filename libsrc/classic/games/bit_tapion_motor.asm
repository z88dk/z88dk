
;
; Start cassette motor and switch the audio input on
; e.g. initialise BC with the input port address
;


    SECTION code_clib


    PUBLIC  bit_tapion_motor
    PUBLIC  _bit_tapion_motor


    EXTERN  bit_open_di

    INCLUDE "classic/games/games.inc"


bit_tapion_motor:
_bit_tapion_motor:

IF  __CPU_GBZ80__||__CPU_INTEL__
    ret
ELSE

;------------------ Target specific section --------------------

    push    af
  IF    FORzx81
    push    de
    EXTERN  zx_fast
    call    zx_fast
    pop     de
    OUT     ($FF), A                   ;   set output bit high
  ELSE

    call    bit_open_di       ; it includes also the ZX Spectrum EAR port activation
 
 ENDIF
    pop     af

  IF    FORlynx
    LD      A, $02                      ; MOTOR ON
    OUT     ($80), A
    LD      A, $0C
    OUT     ($86), A
  ENDIF

  IF    FORmsx
    LD      A, $08
    OUT     ($AB), A                    ; MOTOR ON
    LD      A, 14
    OUT     ($A0), A                    ; Set PSG register for data input port
  ENDIF

  IF    FORsvi
    LD      A, $08
    OUT     ($97), A                    ; MOTOR ON
    LD      A, 14
    OUT     ($88), A                    ; Set PSG register for data input port
  ENDIF

  IF    FORvg5k
    LD      A, 2
    OUT     ($AF), A                    ; MOTOR ON
  ENDIF

  IF    FORmc1000
    LD      A, $0F
    OUT     ($20), A                    ; Set PSG register for data input port
  ENDIF

  IF    FORaquarius
    ld      a, (13312)                  ; save border
    ex      af, af
  ENDIF

  IF    FORc128
    IN      a,(1)
	and     223                         ; Reset BIT 5 (address 1 in the zero page)
    OUT     (1), A                      ; MOTOR ON
  ENDIF

;---------------------------------------------------------------

IF SOUND_ONEBIT_port >= 256
    exx
    ld      bc,SOUND_ONEBIT_port
    exx
ENDIF


    RET


ENDIF

