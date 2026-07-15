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

EXTERN asm_f24_f16
EXTERN asm_f16_f24

PUBLIC asm_f16_frexp

; half_t frexpf (half_t x, int *pw2);
.asm_f16_frexp
    ; evaluation of fraction and exponent
    ;
    ; enter : stack : ret
    ;            bc : int16_t  *pw2
    ;            hl : half_t      x
    ;
    ; exit  :    hl = 16-bit result
    ;            carry reset
    ;
    ; uses  : af, bc, de, hl

    ld a,$7c                    ; isolate packed exponent
    and h
    jr Z,frexp_expand           ; zero / finite
    cp $7c
    jr NZ,frexp_expand

    ; Inf/NaN: *pw2 = 0, return x unchanged
    xor a
    ld (bc),a
    inc bc
    ld (bc),a
    ret                         ; HL = x, NC

.frexp_expand
    call asm_f24_f16            ; convert HL to expanded format

    ld a,d                      ; get the exponent
    and a
    jr Z,zero
    ld d,$7e                    ; fraction in [0.5,1) (f24 bias-1)
    sub d                       ; *pw2 = exp - 0x7e

.zero
    ld (bc),a                   ; and store in pw2
    inc bc
    rlca
    sbc  a
    ld  (bc),a

    jp asm_f16_f24              ; return IEEE HL half_t fraction
