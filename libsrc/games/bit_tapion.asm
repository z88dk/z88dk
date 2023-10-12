
;
; Set up cassette for read
;
; This routine is used prior to any read operation.
; It turns on the cassette motor (where possible) and checks for the carrier.
;
; The bit_tapion routine disables all further interrupts.
; The interrupts are reenabled when bit_tapiof is called.

; Exit status: 0 if the leading tone has been hooked correctly, -1 on error


        SECTION code_clib


        PUBLIC  bit_tapion
        PUBLIC  _bit_tapion


        EXTERN  bit_open_di
        EXTERN  bit_tapiof
        EXTERN  bit_tapin_bit

        PUBLIC  __LOWLIM
        PUBLIC  __WINWID


        INCLUDE "games/games.inc"


bit_tapion:
_bit_tapion:

  IF    __CPU_GBZ80__||__CPU_INTEL__
        ret
  ELSE

;  PUSH HL
;  PUSH DE
;  PUSH BC
;  PUSH AF
;  CALL TAPION
;POPALL:
;  POP AF
;  JR POPALL_0
;
;
;TAPION:
;------------------ Target specific section --------------------
        call    bit_open_di

    IF  FORlynx
        LD      A, $02                  ; MOTOR ON
        OUT     ($80), A
        LD      A, $0C
        OUT     ($86), A
    ENDIF

    IF  FORmsx
        LD      A, $08
        OUT     ($AB), A                ; MOTOR ON
        LD      A, 14
        OUT     ($A0), A                ; Set PSG register for data input port
    ENDIF

    IF  FORsvi
        LD      A, $08
        OUT     ($97), A                ; MOTOR ON
        LD      A, 14
        OUT     ($88), A                ; Set PSG register for data input port
    ENDIF

    IF  FORvg5k
        LD      A, 2
        OUT     ($AF), A                ; MOTOR ON
    ENDIF

    IF  FORmc1000
        LD      A, $0F
        OUT     ($20), A                ; Set PSG register for data input port
    ENDIF

; ZX Spectrum, SAM, TS2068, etc..
    IF  (TAPEIN_ONEBIT_port=$FE)
        out     ($FE), a
    ENDIF

    IF  FORaquarius
        ld      a, (13312)              ; save border
        ex      af, af
    ENDIF


;---------------------------------------------------------------


TAPION_0:
  ;LD HL,1111
        LD      HL, 400

TAPION_1:
        LD      D, C                    ; Get tape block mode
        CALL    bit_tapin_bit
  ;RET C               ; Exit if timeout (or BREAK)
        JP      C, TAPION_ERROR
        LD      A, C                    ; get measured tape sync speed
        CP      250                     ; Timeout ?
  ;CP 150
        JR      NC, TAPION_0            ; Try again
        CP      5                       ; Too short ?
        JR      C, TAPION_0             ; Try again
        SUB     D
        JR      NC, TAPION_2
        CPL
        INC     A
TAPION_2:
        CP      $04
        JR      NC, TAPION_0            ; Try again
        DEC     HL
        LD      A, H
        OR      L
        JR      NZ, TAPION_1            ; Correct leading tone.  It must stay like this 1111 times.

        LD      HL, $0000
        LD      B, L
        LD      D, L
TAPION_3:
        CALL    bit_tapin_bit
  ;RET C               ; Exit if timeout (or BREAK)
        JP      C, TAPION_ERROR
        ADD     HL, BC
        DEC     D
        JP      NZ, TAPION_3
        LD      BC, 1710
        ADD     HL, BC
        LD      A, H
        RRA
        AND     $7F
        LD      D, A
        ADD     HL, HL
        LD      A, H
        SUB     D
        LD      D, A
        SUB     6
        LD      (__LOWLIM), A           ; Keep the minimal length of startbit
        LD      L, A                    ;  set the exit value to LOWLIM
        LD      A, D
        ADD     A, A
        LD      B, $00
        LD      H, B                    ;  set the exit value to LOWLIM
TAPION_4:
        SUB     3
        INC     B
        JR      NC, TAPION_4
        LD      A, B
        SUB     3
        LD      (__WINWID), A           ;  Store the difference between a low-and high-cycle
  ;OR A
        RET

TAPION_ERROR:
        call    bit_tapiof
        LD      HL, -1
        RET


  ENDIF

; Those two parameters are intitialized by bit_tapion()
; in the leading tone sync phase
;


; Mind the "contended memory" when running this on a ZX Spectrum !

;SECTION smc_clib
        SECTION bss_clib


__LOWLIM:
        DEFB    0
__WINWID:
        DEFB    0

