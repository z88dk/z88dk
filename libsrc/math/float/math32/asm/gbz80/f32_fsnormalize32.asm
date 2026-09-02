;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsnormalize32 - gbz80 unpacked 32-bit normalisation
;-------------------------------------------------------------------------
;
;  unpacked: mantissa=dehl, exponent in b, sign in c[7]
;  DEHL is already add hl,hl / rla-through-A layout.
;
;  Same control as 8085: byte scan then residual loop.  gbz80 has no S flag:
;  use bit 7,d / bit 7,a.  bit 7 clobbers Z — do not chain jr nz from a prior or a.

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsnormalize32


.m32_fsnormalize32
    ld a,d
    or a
    jr z,scan_e                     ; D == 0
    bit 7,a
    ret nz                          ; already normalised (hot path)
    jr need_shift                   ; D nonzero, bit7 clear

.scan_e
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
    push hl
    ld h,d
    ld l,e                          ; HL↔DE without ex (56c)
    pop de
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
    jp z,normzero
    bit 7,a
    ret nz                          ; already normalised after byte shift
    ; D nonzero, bit7 clear → need_shift

.need_shift
    push bc                     ; exp + sign
    ld b,0
.shift_loop
    inc b
    add hl,hl
    ld a,e                      ; rl de through A
    rla
    ld e,a
    ld a,d
    rla
    ld d,a
    bit 7,d                     ; until leading one (do not use Z from rla)
    jr z,shift_loop

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
