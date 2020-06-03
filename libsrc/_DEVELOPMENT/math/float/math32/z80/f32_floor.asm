
SECTION code_fp_math32

EXTERN m32_f2ulong
EXTERN m32_float32u
EXTERN m32_float32
EXTERN m32_fssub_callee

PUBLIC m32_floor_fastcall
PUBLIC _m32_floorf


; float floorf(float f) __z88dk_fastcall;
._m32_floorf

; Entry: dehl = floating point number
.m32_floor_fastcall
    bit 7,d
    push af                     ;Save sign flag
    call m32_f2ulong            ;Exits dehl = number
    pop af
    jr NZ,was_negative
    call m32_float32u
    ret

.was_negative
    call m32_float32
    ; And subtract 1
    push de
    push hl
    ld de,$3f80
    ld hl,$0000
    call m32_fssub_callee
    ret
