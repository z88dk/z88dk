
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
    
	EXTERN  bit_tapion_motor

    EXTERN  __LOWLIM
    EXTERN  __WINWID


    INCLUDE "classic/games/games.inc"


bit_tapion:
_bit_tapion:

IF  __CPU_GBZ80__||__CPU_INTEL__
    ret
ELSE


    CALL    bit_tapion_motor

TAPION_0:
  ;LD HL,1111
    LD      HL, 200

TAPION_1:
    LD      D, C
    CALL    bit_tapin_bit
  ;RET C               ; Exit if timeout (or BREAK)
    JP      C, TAPION_ERROR
    LD      A, C                        ; get measured tape sync speed
    CP      250                         ; Timeout ?
  ;CP 150
    JR      NC, TAPION_0                ; Try again
    CP      5                           ; Too short ?
    JR      C, TAPION_0                 ; Try again
    SUB     D
    JR      NC, TAPION_2
    CPL
    INC     A
TAPION_2:
    CP      $04
    JR      NC, TAPION_0                ; Try again
    DEC     HL
    LD      A, H
    OR      L
    JR      NZ, TAPION_1                ; Correct leading tone.  It must stay like this 1111 times.

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
    LD      (__LOWLIM), A               ; Keep the minimal length of startbit
    LD      L, A                        ;  set the exit value to LOWLIM
    LD      A, D
    ADD     A, A
    LD      B, $00
    LD      H, B                        ;  set the exit value to LOWLIM
TAPION_4:
    SUB     3
    INC     B
    JR      NC, TAPION_4
    LD      A, B
    SUB     3
    LD      (__WINWID), A               ;  Store the difference between a low-and high-cycle
  ;OR A
    RET

TAPION_ERROR:
    call    bit_tapiof
    LD      HL, -1
    RET


ENDIF

