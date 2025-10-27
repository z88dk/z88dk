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
;  asm_f16_zero - z80 half floating point signed zero
;-------------------------------------------------------------------------
;
;  unpacked format: exponent in d, sign in e[7], mantissa in hl
;  return normalized result also in unpacked format
;
;  return half float in hl
;
;-------------------------------------------------------------------------

SECTION code_fp_math16

PUBLIC asm_f24_zero
PUBLIC asm_f16_zero

.asm_f24_zero
    ld a,e              ; called from expanded format, sign in e
    and 080h
    ld e,a
    xor a
    ld d,a
    ld h,a
    ld l,a
    ret

.asm_f16_zero
    ld a,e              ; called from expanded format, sign in e
    and 080h
    ld h,a
    ld l,0
    ret

