
SECTION code_crt_clang

PUBLIC __smulu

EXTERN l_mulu_16_16x16

; hl = hl * bc
__smulu:
    push af
    push bc
    push de
    ld e,c
    ld d,b
    call l_mulu_16_16x16
    pop de
    pop bc
    pop af
    ret
