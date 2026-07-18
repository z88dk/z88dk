
SECTION code_fp_math32
PUBLIC cm32_sccz80_pow_callee

EXTERN _m32_powf

; sccz80 entry: SP = ret_outer, y(4), x(4)
; non-callee _m32_powf: SP = ret, y(4), x(4)
; Left-rotate 5 words so ret_outer is under args, call, drop y+x, ret.

.cm32_sccz80_pow_callee
    ld b,0
.pow_bub
    ld a,b
    cp 8
    jp Z,pow_call
    push bc
    ld hl,0
    add hl,sp
    inc hl
    inc hl                          ; skip saved BC
    ld e,a
    ld d,0
    add hl,de
    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld (hl),b
    dec hl
    ld (hl),c
    dec hl
    ld (hl),d
    dec hl
    ld (hl),e
    pop bc
    ld a,b
    add a,2
    ld b,a
    jp pow_bub

.pow_call
    call _m32_powf
    pop bc
    pop bc
    pop bc
    pop bc
    ret
