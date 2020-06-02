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

EXTERN asm_f16_zero
EXTERN asm_f16_f24, asm_f24_f16

PUBLIC asm_f16_ldexp

; half ldexpf (half x, int16_t pw2);
.asm_f16_ldexp
    ; evaluation of fraction and exponent
    ;
    ; enter : stack = int16_t pw2, half x, ret
    ;
    ; exit  :   hl  = 16-bit result
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    pop af                      ; return
    pop hl                      ; (half)x in hl
    pop bc                      ; pw2 maximum int8_t actually
    push af                     ; return on stack

    call asm_f16_f24            ; convert to expanded format

    add a,d                     ; get the exponent
    and a
    jp Z,asm_f16_zero           ; return IEEE signed zero

    add c                       ; pw2
    ld d,a                      ; exponent returned
    jp asm_f24_f16              ; return IEEE HL

