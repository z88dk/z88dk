
SECTION code_l_clang


PUBLIC __bshl
EXTERN l_lsl_hl

; a << c
__bshl:
    inc b
    dec b
    ret z
    push bc
loop:
    add a
    jr nz,loop
    pop bc
    ret
