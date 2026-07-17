;
; 8085 ceilf
;
SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsadd_callee
EXTERN m32_discardfraction

PUBLIC m32_ceil_fastcall
PUBLIC _m32_ceilf

._m32_ceilf
.m32_ceil_fastcall
    call m32_discardfraction
    ret NC
    ld a,d
    and 080h
    ret NZ                      ; negative: trunc is ceil
    push de
    push hl
    ld de,$3f80
    ld hl,$0000
    jp m32_fsadd_callee
