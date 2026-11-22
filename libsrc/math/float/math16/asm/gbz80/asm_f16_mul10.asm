;
;  feilipu, 2020 June / 2026 September (gbz80)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_mul10 - gbz80 floating point multiply by 10 positive
;-------------------------------------------------------------------------
;
; Native srl b / rr c. Overflow rr h / rr l keeps C from add hl,bc.
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

    ld bc,hl                    ; 10*a = (a + a>>2) << 3

    srl b
    rr c
    srl b
    rr c

    add hl,bc
    ld a,3
    jr NC,no_carry

    rr h                        ; C from add
    rr l
    inc a

.no_carry
    add a,d
    jr C,mul10_oflow
    ld d,a
    jp asm_f16_f24

.mul10_oflow
    jp asm_f16_inf
