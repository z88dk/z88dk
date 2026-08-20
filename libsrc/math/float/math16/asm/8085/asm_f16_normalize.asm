;
;  feilipu, 2026 August
;  ped7g, 2026 August
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
;  Byte scan; residual merge loop.  add hl,hl does not set S from H.
;  Until normalised H.7 is 0.  Entry leaves A = H with A.7 clear, so each
;  step is or h / jp p (cheaper than ld a,h / or a).
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
    jr nz,need_shift            ; A = H, A.7 clear

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
    ; A = H, A.7 clear → need_shift

.need_shift
    ld b,0
.shift_loop
    inc b
    add hl,hl
    or h                        ; S from H.7 (A.7 was 0 until then)
    jp p,shift_loop

    ld a,d
    sub b
    jp c,asm_f24_zero
    ld d,a
    ret
