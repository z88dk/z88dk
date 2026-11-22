SECTION code_clib
SECTION code_l_xcc

PUBLIC ___xcc_muluint2ulong

; XCC sdcccall(1) unsigned 16x16 -> 32 multiply.
;
; enter : HL = multiplier, DE = multiplicand
; exit : DE = low word, HL = high word
; uses : F, B, DE, HL, IY

___xcc_muluint2ulong:
    ld iy,0
    ld b,16
muluint2ulong_loop:
    add iy,iy
    adc hl,hl
    jr nc,muluint2ulong_skip
    add iy,de
    jr nc,muluint2ulong_skip
    inc hl
muluint2ulong_skip:
    djnz muluint2ulong_loop
    push iy
    pop de
    ret
