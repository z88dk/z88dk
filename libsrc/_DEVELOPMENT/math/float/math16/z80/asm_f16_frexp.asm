;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_frexp - z80, z180, z80n fraction and exponent
;-------------------------------------------------------------------------

SECTION code_fp_math16

EXTERN asm_f16_f24, asm_f24_f16

PUBLIC asm_f16_frexp

; half frexpf (half x, int *pw2);
.asm_f16_frexp
    ; evaluation of fraction and exponent
    ;
    ; enter : stack =  int16_t *pw2, half x,ret
    ;
    ; exit  : dehl  = 32-bit result
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    pop af                      ; return
    pop hl                      ; (half)x in hl
    pop bc                      ; (int16_t*)pw2
    push af                     ; return on stack

    call asm_f16_f24            ; convert to expanded format

    ld a,d                      ; get the exponent
    and a
    jr Z,zero
    ld d,$7e                    ; remove exponent excess (bias-1)
    sub d                       ; mantissa between 0.5 and 1

.zero
    ld (bc),a                   ; and store in pw2
    inc bc
    rlca
    sbc  a
    ld  (bc),a

    jp asm_f24_f16              ; return IEEE HL fraction

