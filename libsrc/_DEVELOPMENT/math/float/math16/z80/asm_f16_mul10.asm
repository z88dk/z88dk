;
;  feilipu, 2020 June
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_mul10 - z80, z180, z80n floating point multiply by 10 positive
;-------------------------------------------------------------------------

SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24
EXTERN asm_f16_zero
EXTERN asm_f16_inf

PUBLIC asm_f16_mul10

.asm_f16_mul10
    call asm_f24_f16            ; convert to expanded format

    ld a,d                      ; get the exponent
    and a
    jp Z,asm_f16_zero

    ld b,h                      ; 10*a = 2*(4*a + a)
    ld c,l                      ; hl *= 10

    srl b
    rr c
    srl b
    rr c

    add hl,bc
    ld a,3                      ; exponent increase
    jr NC,no_carry

    rr h                        ; shift if a carry
    rr l
    inc a                       ; and increment exponent

.no_carry
    add a,d                     ; resulting exponent
    ld d,a                      ; return the exponent
    inc a                       ; ensure not infinity
    jp Z,asm_f16_inf
    jp asm_f16_f24              ; return IEEE HL

