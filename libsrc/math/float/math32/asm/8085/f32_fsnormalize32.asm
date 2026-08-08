;
;  feilipu, 2026 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsnormalize32 - 8085 unpacked 32-bit normalisation
;-------------------------------------------------------------------------
;
;  unpacked: mantissa=dehl, exponent in b, sign in c[7]
;  DEHL is already add hl,hl / rl de layout.
;
;  Byte scan; unrolled residual walk jumps into reverse-label shift tree.
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsnormalize32


.m32_fsnormalize32
    ld a,d
    or a
    ret m
    jr nz,bitwalk

    ld a,e
    or a
    jr nz,need8

    ld a,h
    or a
    jr nz,need16

    ld a,l
    or a
    jp z,normzero

    ld d,l
    ld e,0
    ld hl,0
    ld a,b
    sub 24
    ld b,a
    jp c,normzero
    jp got_lead

.need16
    ex de,hl
    ld a,b
    sub 16
    ld b,a
    jp c,normzero
    jp got_lead

.need8
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,b
    sub 8
    ld b,a
    jp c,normzero

.got_lead
    ld a,d
    or a
    ret m
    jp z,normzero

.bitwalk
    push bc                     ; exp + sign
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
    jp p,bitwalk_zero           ; 7th trial still clear → zero
    ; fall through to s7

.s7
    add hl,hl
    rl de
.s6
    add hl,hl
    rl de
.s5
    add hl,hl
    rl de
.s4
    add hl,hl
    rl de
.s3
    add hl,hl
    rl de
.s2
    add hl,hl
    rl de
.s1
    add hl,hl
    rl de

    ld a,b
    pop bc
    cpl
    inc a
    add a,b
    jp nc,normzero
    ld b,a
    ret

.bitwalk_zero
    pop bc                      ; drop exp+sign
.normzero
    xor a
    ld b,a
    ld d,a
    ld e,a
    ld h,a
    ld l,a
    ret
