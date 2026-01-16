;
;  Copyright (c) 2020 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, 2020 May
;
;-------------------------------------------------------------------------
;  asm_f16_inf - z80 half floating point signed infinity
;-------------------------------------------------------------------------
;
;  unpacked format: exponent in d, sign in e[7], mantissa in hl
;  return normalized result also in unpacked format
;
;  return half float in hl
;
;-------------------------------------------------------------------------

SECTION code_fp_math16

PUBLIC asm_f24_inf
PUBLIC asm_f16_inf

.asm_f24_inf
    ld a,e              ; called from expanded format, sign in e
    and 080h            ; preserve sign
    ld e,a
    xor a
    ld h,a              ; clear mantissa
    ld l,a
    dec a
    ld d,a              ; load 0xFF exponent
    ret

.asm_f16_inf
    ld a,e              ; called from expanded format, sign in e
    and 080h            ; preserve sign
    or 07Ch             ; set infinity exponent
    ld h,a              ; set sign, exponent
    ld l,0
    ret

