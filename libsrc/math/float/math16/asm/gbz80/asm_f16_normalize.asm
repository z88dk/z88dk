;
;  feilipu, 2026 September (gbz80)
;  ped7g, 2026 September (gbz80)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f24_normalize - gbz80 half floating point unpacked normalisation
;-------------------------------------------------------------------------
;
;  unpacked: exponent in d, sign in e[7], mantissa in hl
;
;  No S flag: leading-one tests use bit 7,h (not ret m / jp p).
;  Residual loop is at most 7 after the byte scan.
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

EXTERN asm_f24_zero

PUBLIC asm_f24_normalize


.asm_f24_normalize
    bit 7,h
    ret nz                      ; already normalised
    ld a,h
    or a
    jr nz,need_shift

    ld a,l
    or a
    jp z,asm_f24_zero

    ld h,l
    ld l,0
    ld a,d
    sub 8
    ld d,a
    jp c,asm_f24_zero

    bit 7,h
    ret nz
    ld a,h
    or a
    jp z,asm_f24_zero

.need_shift
    ld b,0
.shift_loop
    inc b
    add hl,hl
    bit 7,h
    jr z,shift_loop

    ld a,d
    sub b
    jp c,asm_f24_zero
    ld d,a
    ret
