

SECTION code_clib
PUBLIC joystick
PUBLIC _joystick

EXTERN getk


joystick:
_joystick:
    ld      a,l
    ld      c,$20
    cp      1
    jr      z,read_stick
    ld      c,$40
    cp      2
    jr      z,read_stick
    cp      3
    jr      nz,no_stick_qaop
    INCLUDE "games/joystick_qaop.as1"
no_stick_qaop:
    cp      4
    jr      nz,no_stick_8246
    INCLUDE "games/joystick_8246.as1"
no_stick_8246:
    ld      hl,0
    ret

;    practic 1/88 
;
;     Bit 0 - links
;        1 - rechts
;        2 - runter
;        3 - hoch
;        4 - Aktionstast
;
;   Left and right are swapped from z88dk


; Read a joystick
; Entry: c = stick address, $20,$40
; Exit: hl = keys
read_stick:
    ld      a,$CF
    out     ($01),a
    ld      a,$1f
    out     ($01),a
    ld      a,c     ;c=$20/$40 for sticks
    out     ($00),a
    in      a,($00)
    and     31
    ld      hl,0
    ret     z
normalise_stick:
    cpl
    and     31
    ld      c,0
    rra             ;Left
    rl      c
    rrca            ;Right
    rl      c
    rla
    rla
    and     @00011100
    or      c
    ld      l,a
    ld      h,0
    ret
