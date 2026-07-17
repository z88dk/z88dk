;
; 8085 m32_fsmul2 — multiply by 2 (increment exponent)
;
SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsmul2_fastcall
PUBLIC _m32_mul2f

._m32_mul2f
.m32_fsmul2_fastcall
    rl de                       ; exp in d, sign in C

    inc d
    dec d
    jp Z,zero_legal

    inc d                       ; *2
    jr Z,exp_max
    ld a,d
    inc a
    jr Z,overflow

    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ret

.exp_max
    dec d
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

.overflow
    ld e,0
    ld h,e
    ld l,e
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    scf
    ret
