;
;	Game device library for the MSX
;       Stefano Bodrato - 3/12/2007
;
;	$Id: joystick.asm,v 1.9 2016-06-16 20:23:51 dom Exp $
;

        SECTION code_clib
        PUBLIC    joystick
        PUBLIC    _joystick
        EXTERN    getk

        EXTERN  __nabu_j1
        EXTERN  __nabu_j2

.joystick
._joystick
    ;__FASTCALL__ : joystick no. in HL

    ld      a,l
    ld      hl,__nabu_j1
    dec     a
    jr      z,doread
    ld      hl,__nabu_j2
    dec     a
    jr      z,doread
    dec     a
    jr      z,j_qaop
    dec     a
    jr      z,j_8246
    ld      hl,0
    ret


doread:
    ld      d,(hl)
; Nabu:  ...FURDL
; z88dk: ...FUDLR
    ld      a,d
    and     7
    ld      c,a
    ld      b,0
    ld      hl,table
    add     hl,bc
    ld      a,d
    and     @00011000
    or      (hl)
    ld      l,a
    ld      h,0
    ret



j_qaop:
    INCLUDE "games/joystick_qaop.as1"

j_8246:
    INCLUDE "games/joystick_8246.as1"



    SECTION rodata_clib

table:
    defb    @00000000
    defb    @00000010       ;LEFT
    defb    @00000100       ;DOWN
    defb    @00000110       ;LEFT+DOWN
    defb    @00000001       ;RIGHT
    defb    @00000011       ;LEFT+RIGHT - not possible
    defb    @00000101       ;RIGHT+DOWN
    defb    @00000111       ;LEFT+RIGHT+DOWN = not possible
