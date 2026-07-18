
SECTION code_fp_math32
PUBLIC cm32_sccz80_fmod_callee

EXTERN _m32_fmodf

; Same left-rotate callee bridge as pow.

.cm32_sccz80_fmod_callee
    ld b,0
.fmod_bub
    ld a,b
    cp 8
    jp Z,fmod_call
    push bc
    ld hl,0
    add hl,sp
    inc hl
    inc hl
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
    jp fmod_bub

.fmod_call
    call _m32_fmodf
    pop bc
    pop bc
    pop bc
    pop bc
    ret
