;
; 8085 m32_fsdiv2 — divide by 2 (decrement exponent)
;
SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsdiv2_fastcall
PUBLIC _m32_div2f

._m32_div2f
.m32_fsdiv2_fastcall
    rl de

    inc d
    dec d
    jp Z,zero_legal

    ld a,d
    inc a
    jr Z,exp_max                ; Inf/NaN unchanged

    dec d
    jr Z,zero_underflow

    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ret

.exp_max
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ret

.zero_legal
    ld e,d
    ld hl,de
    ld a,d
    rra
    ld d,a
    ret

.zero_underflow
    ld e,d
    ld hl,de
    ld a,d
    rra
    ld d,a
    scf
    ret
