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
;  asm_f16_neg - z80 half floating point negate
;-------------------------------------------------------------------------
;
;  unpacked format: exponent in d, sign in e[7], mantissa in hl
;  return normalized result also in unpacked format
;
;  return half float in hl
;
;-------------------------------------------------------------------------

SECTION code_fp_math16

PUBLIC asm_f24_neg
PUBLIC asm_f16_neg

.asm_f24_neg
    ld a,e
    xor 080h
    ld e,a
    ret

.asm_f16_neg
    ld a,h
    xor 080h
    ld h,a
    ret

