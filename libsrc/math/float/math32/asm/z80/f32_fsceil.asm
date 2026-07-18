
SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsadd_callee
EXTERN m32_discardfraction

PUBLIC m32_ceil_fastcall
PUBLIC _m32_ceilf


; float ceilf(float f) __z88dk_fastcall;
._m32_ceilf

; Entry: dehl = floating point number
.m32_ceil_fastcall
    call m32_discardfraction
    ret NC                      ; already integer
    bit 7,d
    ret NZ                      ; negative -> trunc is ceil

    ; positive with fraction: trunc + 1
    push de
    push hl
    ld de,$3f80
    ld hl,$0000
    jp m32_fsadd_callee
