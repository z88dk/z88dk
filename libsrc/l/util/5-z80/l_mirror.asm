
SECTION code_clib
SECTION code_l

PUBLIC l_mirror

.l_mirror
    ; reverse or mirror the bits in a byte
    ; 76543210 -> 01234567
    ;
    ; 18 bytes / 70 cycles
    ;
    ; from http://www.retroprogramming.com/2014/01/fast-z80-bit-reversal.html
    ;
    ; enter :  a = byte
    ;
    ; exit  :  a, l = byte reversed
    ; uses  : af, l
    

    ld l,a      ; a = 76543210
    rlca
    rlca        ; a = 54321076
    xor l
    and 0xAA
    xor l       ; a = 56341270
    ld l,a
    rlca
    rlca
    rlca        ; a = 41270563
    rrc l       ; l = 05634127
    xor l
    and 0x66
    xor l       ; a = 01234567
    ld l,a
    ret
