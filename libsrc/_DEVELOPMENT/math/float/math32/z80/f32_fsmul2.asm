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
; FIXME clocks
;-------------------------------------------------------------------------

SECTION code_fp_math32

PUBLIC m32_fsmul2_fastcall
PUBLIC _m32_mul2f


._m32_mul2f
.m32_fsmul2_fastcall
    sla e                       ; get exponent in d
    rl d                        ; put sign in C
    jr Z,zero_legal             ; return IEEE zero

    inc d                       ; multiply by 2
    jr Z,infinity               ; capture NaN
    inc d
    jr Z,infinity               ; capture overflow
    dec d

    rr d                        ; return sign and exponent
    rr e
    ret                         ; return IEEE DEHL

.zero_legal
    ld e,d                      ; use 0
    ld h,d
    ld l,d        
    rr d                        ; restore the sign
    ret                         ; return IEEE signed ZERO in DEHL

.infinity
    ld e,d                      ; use 0
    ld h,d
    ld l,d
    dec d                       ; 0xff
    rr d                        ; restore the sign
    rr e
    scf
    ret                         ; return IEEE signed INFINITY in DEHL
