;
;  feilipu, 2026 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f24_normalize - 8085 half floating point unpacked normalisation
;-------------------------------------------------------------------------
;
;  unpacked: exponent in d, sign in e[7], mantissa in hl
;
;  Byte scan; unrolled residual walk jumps into reverse-label add hl,hl tree.
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

EXTERN asm_f24_zero

PUBLIC asm_f24_normalize


.asm_f24_normalize
    ld a,h
    or a
    ret m                       ; already normalised
    jr nz,bitwalk

    ld a,l
    or a
    jp z,asm_f24_zero

    ld h,l
    ld l,0
    ld a,d
    sub 8
    ld d,a
    jp c,asm_f24_zero

    ld a,h
    or a
    ret m
    jp z,asm_f24_zero

.bitwalk
    ld b,1
    add a,a
    jp m,s1
    inc b
    add a,a
    jp m,s2
    inc b
    add a,a
    jp m,s3
    inc b
    add a,a
    jp m,s4
    inc b
    add a,a
    jp m,s5
    inc b
    add a,a
    jp m,s6
    inc b
    add a,a
    jp p,asm_f24_zero           ; 7th trial still clear → zero
    ; fall through to s7

.s7
    add hl,hl
.s6
    add hl,hl
.s5
    add hl,hl
.s4
    add hl,hl
.s3
    add hl,hl
.s2
    add hl,hl
.s1
    add hl,hl

    ld a,d
    sub b
    jp c,asm_f24_zero
    ld d,a
    ret
