;
;  feilipu, 2026 July
;  ped7g, 2026 July
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
;  Byte scan; residual merge loop.  8085 rl de does not set S (-----VC).
;  Until normalised D.7 is 0.  Entry leaves A = D with A.7 clear, so each
;  step is or d / jp p (cheaper than ld a,d / or a).

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsnormalize32


.m32_fsnormalize32
    ld a,d
    or a
    ret m
    jr nz,need_shift            ; A = D, A.7 clear

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
    jp bitshift_check

.need16
    ex de,hl
    ld a,b
    sub 16
    ld b,a
    jp c,normzero
    jp bitshift_check

.need8
    ld d,e
    ld e,h
    ld h,l
    ld l,0
    ld a,b
    sub 8
    ld b,a
    jp c,normzero
    ; fall through

.bitshift_check
    ld a,d
    or a
    ret m
    jp z,normzero
    ; A = D, A.7 clear → need_shift

.need_shift
    push bc                     ; exp + sign
    ld b,0
.shift_loop
    inc b
    add hl,hl
    rl de                       ; 8085 RDEL: flags -----VC (S not set)
    or d                        ; S from D.7 (A.7 was 0 until then)
    jp p,shift_loop

    ld a,b
    pop bc
    cpl
    inc a
    add a,b
    jp nc,normzero
    ld b,a
    ret

.normzero
    xor a
    ld b,a
    ld d,a
    ld e,a
    ld h,a
    ld l,a
    ret
