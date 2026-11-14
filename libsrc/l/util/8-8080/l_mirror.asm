;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Reverse the bits in one byte.
;	76543210 -> 01234567
;
;	The Z80 and gbz80 forms use rrc l. This form is the same steps
;	with rrca. 8080, 8085, and vm1 link this file.
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
    push    af                          ; 8080: rrc l is not legal
    ld      a, l
    rrca
    ld      l, a                        ; l = 05634127
    pop     af
    xor     l
    and     $66
    xor     l                           ; a = 01234567
    ld      l, a
    ret
