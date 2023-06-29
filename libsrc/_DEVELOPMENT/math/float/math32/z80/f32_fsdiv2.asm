;
;  feilipu, 2019 June
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsdiv2 - z80, z180, z80n floating point divide by 2
;-------------------------------------------------------------------------
; 
; Division by 2 is decrementing the exponent. An easy optimisation.
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsdiv2_fastcall
PUBLIC _m32_div2f


._m32_div2f
.m32_fsdiv2_fastcall
    sla e                       ; get exponent in d
    rl d                        ; put sign in C
    jr Z,zero_legal             ; return IEEE zero

    dec d                       ; divide by 2
    jr Z,zero_underflow         ; capture underflow zero

    rr de                       ; return sign and exponent
    ret                         ; return IEEE DEHL

.zero_legal
    ld e,d                      ; use 0
    ld hl,de
    rr d                        ; restore the sign
    ret                         ; return IEEE signed ZERO in DEHL

.zero_underflow
    ld e,d                      ; use 0
    ld hl,de
    rr d                        ; restore the sign
    scf
    ret                         ; return IEEE signed ZERO in DEHL
