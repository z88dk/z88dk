;
;  feilipu, 2020 June
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_div2 - z80, z180, z80n floating point divide by 2
;-------------------------------------------------------------------------
; 
;  Division by 2 is decrementing the exponent. An easy optimisation.
;
;-------------------------------------------------------------------------

SECTION code_fp_math16

PUBLIC asm_f16_div2

.asm_f16_div2
    ld a,$7c                    ; isolate exponent
    and h                       ; get exponent in a
    jr Z,zero_legal             ; return IEEE zero

    ld a,h                      ; load exponent
    sub 00000100b               ; divide by 2
    ld h,a
    and $7c
    jr Z,zero_underflow         ; capture underflow zero
    ret                         ; return IEEE DEHL

.zero_legal
    rl h                        ; put sign in C
    ld h,a                      ; use 0
    ld l,a       
    rr h                        ; restore the sign
    ret                         ; return IEEE signed ZERO in DEHL

.zero_underflow
    rl h                        ; put sign in C
    ld h,a                      ; use 0
    ld l,a
    rr h                        ; restore the sign
    scf
    ret                         ; return IEEE signed ZERO in DEHL
