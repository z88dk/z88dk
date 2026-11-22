;
;  feilipu, 2020 June / 2026 September (8085)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_mul10 - 8085 floating point multiply by 10 positive
;-------------------------------------------------------------------------
;
; 10*a = (a + a>>2) << 3. Orig in BC; a>>2 in HL via one logical >>
; through A then sra hl (H7 is 0). Overflow rr still through A (C from add).
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24
EXTERN asm_f16_zero
EXTERN asm_f16_inf

PUBLIC asm_f16_mul10

.asm_f16_mul10
    ld a,$7c
    and h
    jr Z,mul10_expand
    cp $7c
    ret Z

.mul10_expand
    call asm_f24_f16

    ld a,d
    and a
    jp Z,asm_f16_zero

    ld bc,hl                    ; orig mantissa
    or a
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    sra hl                      ; second logical >> (H7 is 0)
    add hl,bc
    ld a,3
    jr NC,no_carry

    ld b,a
    ld a,h                      ; rr hl through C from add
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ld a,b
    inc a

.no_carry
    add a,d
    jr C,mul10_oflow
    ld d,a
    jp asm_f16_f24

.mul10_oflow
    jp asm_f16_inf
