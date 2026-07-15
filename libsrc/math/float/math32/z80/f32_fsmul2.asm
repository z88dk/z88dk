;
;  feilipu, 2019 June
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsmul2 - z80, z180, z80n floating point multiply by 2
;-------------------------------------------------------------------------
; 
; Multiplication by 2 is incrementing the exponent. An easy optimisation.
;
;-------------------------------------------------------------------------

SECTION code_fp_math32

PUBLIC m32_fsmul2_fastcall
PUBLIC _m32_mul2f


._m32_mul2f
.m32_fsmul2_fastcall
    sla e                       ; get exponent in d
    rl d                        ; put sign in C
    jr Z,zero_legal             ; return IEEE zero

    inc d                       ; *2
    jr Z,exp_max                ; was 0xff: Inf/NaN, restore
    ld a,d
    inc a
    jr Z,overflow               ; was 0xfe: overflow to Inf

    rr de                       ; return sign and exponent
    ret                         ; return IEEE DEHL

.exp_max
    dec d                       ; restore exp 0xff
    rr de                       ; original Inf/NaN
    ret

.zero_legal
    ld e,d                      ; use 0
    ld hl,de
    rr d                        ; restore the sign
    ret                         ; return IEEE signed ZERO in DEHL

.overflow
    ld e,0                      ; d is already 0xff
    ld h,e
    ld l,e
    rr de                       ; restore the sign
    scf
    ret                         ; return IEEE signed INFINITY in DEHL
