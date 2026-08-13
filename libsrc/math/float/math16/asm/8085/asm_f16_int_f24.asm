;
;  feilipu, May 2020 / 2026 July (8085)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_int_f24 - int to f24
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_normalize

PUBLIC asm_f24_i8
PUBLIC asm_f24_i16
PUBLIC asm_f24_u8
PUBLIC asm_f24_u16

.asm_f24_i8
    ld a,l
    rla
    sbc a,a
    ld h,a

.asm_f24_i16
    ld d,142
    ld e,h
    ld a,h
    rla
    jp NC,asm_f24_normalize
    xor a
    sub a,l
    ld l,a
    sbc a,a
    sub a,h
    ld h,a
    jp asm_f24_normalize

.asm_f24_u8
    ld h,0

.asm_f24_u16
    ld d,142
    ld a,e
    and 07fh
    ld e,a
    jp asm_f24_normalize
