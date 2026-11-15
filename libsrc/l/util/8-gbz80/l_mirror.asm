;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Reverse the bits in one byte.
;	76543210 -> 01234567
;
;	Same straight-line steps as the Z80 routine. rrc l is native here.
;	gbz80 does not take the Z80 library list, so this copy is the one it links.
;
;	enter :  a = byte
;	exit  :  a, l = byte reversed
;	uses  :  af, l
;

    SECTION code_clib
    SECTION code_l

    PUBLIC  l_mirror

l_mirror:
    ld      l, a                        ; a = 76543210
    rlca
    rlca                                ; a = 54321076
    xor     l
    and     $aa
    xor     l                           ; a = 56341270
    ld      l, a
    rlca
    rlca
    rlca                                ; a = 41270563
    rrc     l                           ; l = 05634127
    xor     l
    and     $66
    xor     l                           ; a = 01234567
    ld      l, a
    ret
