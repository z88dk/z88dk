;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 m32_fsldexp / m32_dmulpow2 — x * 2^n
; Stack only (no BSS).
;

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsmin

PUBLIC m32_dmulpow2
PUBLIC m32_fsldexp_callee
PUBLIC _m32_ldexpf


; HL = signed power; DEHL = float x (same register bank on 8085)
.m32_dmulpow2
    ld b,h
    ld c,l                          ; BC = power; C used
    jp pow2


; stack = int16_t pw2, float x, ret
._m32_ldexpf
.m32_fsldexp_callee
    pop af                          ; ret
    pop hl                          ; x LSW
    pop de                          ; x MSW
    pop bc                          ; pw2
    push af

.pow2
    ; DEHL = x, C = pw2 low (int8 range)
    ld a,e
    add a,a
    ld e,a                          ; sla e
    ld a,d
    rla
    ld d,a                          ; rl d → D=exp, C=sign
    or a
    jp Z,zero_legal

    ld a,e
    rra
    ld e,a                          ; rr e → sign in E[7]

    ld a,d
    inc a
    jp Z,ldexp_pack                 ; Inf/NaN

    ld a,d
    add a,c
    jp C,ldexp_wrap

    or a
    jp Z,ldexp_uflow
    ld d,a
    inc a
    jp Z,ldexp_oflow

.ldexp_pack
    ld a,e
    add a,a                         ; sign → C
    ld e,a
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    or a
    ret

.ldexp_wrap
    ld a,c
    rla
    jp C,ldexp_uflow

.ldexp_oflow
    ld a,e
    and 080h
    or 07fh
    ld d,a
    ld e,080h
    ld hl,0
    scf
    ret

.ldexp_uflow
    ld a,e
    add a,a
    ld d,0
    ld a,0
    rra
    ld d,a
    ld e,0
    ld h,0
    ld l,0
    jp m32_fsmin

.zero_legal
    ; D=0 after shift; C=sign
    ld e,0
    ld h,0
    ld l,0
    ld a,0
    rra
    ld d,a
    ret
