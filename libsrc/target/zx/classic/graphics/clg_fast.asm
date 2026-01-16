;
;       Fast CLS for the Speccy
;       Stefano - 10/1/2007
;
;
;	$Id: clg_fast.asm,v 1.6 2016-04-22 20:17:17 dom Exp $
;

    SECTION code_clib
    PUBLIC  clg_fast
    PUBLIC  _clg_fast

clg_fast:
_clg_fast:
    ld      a, i
    push    af
    di

    ld      hl, 0
    ld      d, h
    ld      e, h
    ld      b, h
    add     hl, sp
    ld      sp, 16384+6144
clg_fastloop:
    push    de
    push    de
    push    de
    push    de

    push    de
    push    de
    push    de
    push    de

    push    de
    push    de
    push    de
    push    de

    djnz    clg_fastloop

    ld      sp, hl
    pop     af
    ret     po
    ei
    ret
