;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Reverse the bits in one byte.
;	76543210 -> 01234567
;
;	8080, 8085, and vm1 link this file. The Z80 form uses rrc l.
;	19 bytes, including ret.
;	73 cycles on 8080 and vm1, 70 on 8085. ret is not counted.
;	ld r,r is 4 cycles on the 8085.
;
;	Adapted from
;	https://wikiti.brandonw.net/index.php?title=Z80_Routines:Optimized:reverseA
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
    rrca
    rrca                                ; a = 10765432
    xor     l
    and     $aa
    xor     l                           ; a = 16745230
    ld      l, a
    rrca
    rrca
    rrca
    rrca                                ; a = 52301674
    xor     l
    and     $66
    xor     l                           ; a = 12345670
    rrca                                ; a = 01234567
    ld      l, a
    ret
