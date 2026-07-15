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
;  asm_f16_nan - z80 half floating point not a number
;-------------------------------------------------------------------------
;
;  unpacked format: exponent in d, sign in e[7],  mantissa in hl
;  return normalized result also in unpacked format
;
;  return half float in hl
;
;-------------------------------------------------------------------------

SECTION code_fp_math16

PUBLIC asm_f24_nan
PUBLIC asm_f16_nan

.asm_f24_nan
    ; Same exp class as asm_f24_inf (143); nonzero mant → half Inf via pack
    ; (master pack has no separate f24 NaN path; use packed asm_f16_nan for half).
    ld de,08F00h                ; d=143, e=0
    ld hl,04000h
    ret

.asm_f16_nan
    ld hl,07C80h                ; +qNaN
    ret


