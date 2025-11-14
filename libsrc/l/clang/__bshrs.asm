
SECTION code_l_clang


PUBLIC __bshrs
EXTERN l_lsl_hl

; a >> c
__bshrs:
    inc b
    dec b
    ret z
    push bc
loop:
    sra a
    jr nz,loop
    pop bc
    ret
