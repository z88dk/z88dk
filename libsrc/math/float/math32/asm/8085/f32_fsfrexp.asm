;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 frexpf — fraction and exponent (mirror Z80 f32_fsfrexp).
; Never park return addresses in AF (8080/8085 F is not a full byte latch).
;

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsfrexp_callee
PUBLIC _m32_frexpf


; float frexpf (float x, int *pw2);
; enter : stack = float *pw2, float x, ret
; exit  : DEHL = fraction in [0.5, 1); *pw2 = frexp exponent
._m32_frexpf
.m32_fsfrexp_callee
    ; Entry SP: ret, x.HL, x.DE, pw2
    pop bc                          ; BC = ret
    pop hl                          ; x.HL
    pop de                          ; x.DE  → DEHL = x
    ; SP: pw2
    push bc                         ; SP: ret, pw2
    push de
    push hl                         ; SP: x.HL, x.DE, ret, pw2
    ld hl,0
    add hl,sp
    ld de,6
    add hl,de
    ld c,(hl)
    inc hl
    ld b,(hl)                       ; BC = pw2
    pop hl
    pop de                          ; DEHL = x
    ; SP: ret, pw2
    push de
    push hl                         ; SP: x.HL, x.DE, ret, pw2
    pop hl
    pop de                          ; DEHL = x
    pop hl                          ; HL = ret
    ; SP: pw2
    inc sp
    inc sp                          ; drop leftover pw2
    push hl                         ; SP: ret
    ; BC = pw2, DEHL = x

    rl de                           ; exp in D, sign → CF
    ld a,e
    rra
    ld e,a                          ; sign in E[7]

    ld a,d
    ld d,0
    and a
    jp Z,frexp_zero
    ld d,07eh
    sub d

.frexp_zero
    ld (bc),a
    inc bc
    rlca
    sbc a,a
    ld (bc),a

    ld a,e
    rla
    ld e,a
    ld a,d
    rra
    ld d,a
    ld a,e
    rra
    ld e,a
    ret
