
SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fssub_callee
EXTERN m32_discardfraction

PUBLIC m32_floor_fastcall
PUBLIC _m32_floorf


; float floorf(float f) __z88dk_fastcall;
._m32_floorf

; Entry: dehl = floating point number
.m32_floor_fastcall
    call m32_discardfraction
    bit 7,d
    ret Z

.was_negative
    ; And subtract 1
    push de
    push hl
    ld de,$3f80
    ld hl,$0000
    call m32_fssub_callee
    ret
