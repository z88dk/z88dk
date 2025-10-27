
SECTION code_l_clang


PUBLIC __bshru
EXTERN l_lsl_hl

; a >> c
__bshru:
    inc b
    dec b
    ret z
    push bc
loop:
    srl a
    jr nz,loop
    pop bc
    ret
