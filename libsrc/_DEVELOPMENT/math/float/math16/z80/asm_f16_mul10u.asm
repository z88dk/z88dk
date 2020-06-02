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

EXTERN asm_f16_inf, asm_f16_zero
EXTERN asm_f16_f24, asm_f24_f16

PUBLIC asm_f16_mul10u

.asm_f16_mul10u
    call asm_f16_f24            ; convert to expanded format

    ld a,d
    ld d,0
    and a
    jp Z,asm_f16_zero

    ld d,h                      ; 10*a = 2*(4*a + a)
    ld e,l                      ; hl *= 10

    srl h
    rr l
    srl h
    rr l

    add hl,de
    ld a,3                      ; exponent increase
    jr NC,no_carry

    rr h                        ; shift if a carry
    rr l
    inc a                       ; and increment exponent

.no_carry
    add a,d                     ; resulting exponent
    jp C,asm_f16_inf
    jp asm_f24_f16              ; return IEEE HL

