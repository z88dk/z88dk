;
;  Copyright (c) 2020 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, 2020 May / 2026 July (8085)
;
;-------------------------------------------------------------------------
;  asm_f16_fabs - 8085 half floating point absolute value
;-------------------------------------------------------------------------
;
;  unpacked format: exponent in d, sign in e[7], mantissa in hl
;  return half float in hl
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

PUBLIC asm_f24_fabs
PUBLIC asm_f16_fabs

.asm_f24_fabs
    ld a,e
    and 07fh
    ld e,a
    ret

.asm_f16_fabs
    ld a,h
    and 07fh
    ld h,a
    ret
