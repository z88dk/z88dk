;
;  feilipu, 2020 June
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_mul2 - z80, z180, z80n floating point multiply by 2
;-------------------------------------------------------------------------
; 
;  Multiplication by 2 is incrementing the exponent. An easy optimisation.
;
;-------------------------------------------------------------------------

SECTION code_fp_math16

PUBLIC asm_f16_mul2

.asm_f16_mul2
    ld a,$7c                    ; isolate exponent
    and h                       ; get exponent in a
    jr Z,zero_legal             ; return IEEE zero

    ld a,h                      ; load exponent
    add 00000100b               ; multiply by 2
    ld h,a
    cpl
    and $7c
    jr Z,infinity               ; capture overflow
    ret                         ; return IEEE DEHL

.zero_legal
    rl h                        ; put sign in C
    ld h,a                      ; use 0
    ld l,a       
    rr h                        ; restore the sign
    ret                         ; return IEEE signed ZERO in DEHL

.infinity
    rl h                        ; put sign in C
    ld hl,$f800                 ; use infinity $7c<<1
    rr h                        ; restore the sign
    scf
    ret                         ; return IEEE signed INFINITY in DEHL
