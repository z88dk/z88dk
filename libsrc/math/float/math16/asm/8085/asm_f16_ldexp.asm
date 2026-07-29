;
;  feilipu, 2019 May / 2026 July (8085)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_ldexp
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24
EXTERN asm_f16_zero

PUBLIC asm_f16_ldexp

.asm_f16_ldexp
    ; stack : ret
    ;    bc : int16_t pw2
    ;    hl : half_t x
    ld a,$7c
    and h
    jr Z,ldexp_expand
    cp $7c
    ret Z

.ldexp_expand
    call asm_f24_f16
    ld a,d
    and a
    jp Z,asm_f16_zero
    add a,c
    ld d,a
    jp asm_f16_f24
