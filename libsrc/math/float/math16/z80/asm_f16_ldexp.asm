;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_ldexp - z80, z180, z80n load exponent
;-------------------------------------------------------------------------

SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24

EXTERN asm_f16_zero

PUBLIC asm_f16_ldexp

; half_t ldexpf (half_t x, int16_t pw2);
.asm_f16_ldexp
    ; evaluation of fraction and exponent
    ;
    ; enter : stack : ret
    ;            bc : int16_t   pw2
    ;            hl : half_t      x
    ;
    ; exit  :    hl = 16-bit result
    ;            carry reset
    ;
    ;
    ; uses  : af, bc, de, hl

    call asm_f24_f16            ; convert to expanded format

    ld a,d                      ; get the exponent
    and a
    jp Z,asm_f16_zero           ; return IEEE signed zero

    add c                       ; pw2
    ld d,a                      ; exponent returned
    jp asm_f16_f24              ; return IEEE HL half_t

