;
;  feilipu, 2019 June
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsmul2 - z80, z180, z80-zxn floating point multiply by 2
;-------------------------------------------------------------------------
; 
; Multiplication by 2 is incrementing the exponent. An easy optimisation.
;
;-------------------------------------------------------------------------
; FIXME clocks
;-------------------------------------------------------------------------

SECTION code_fp_math32

EXTERN m32_fsmax_fastcall

PUBLIC m32_fsmul2_fastcall
PUBLIC _m32_mul2f


._m32_mul2f
.m32_fsmul2_fastcall
    sla e                       ; get exponent in d
    rl d
    inc d                       ; multiply by 2
    jp Z,m32_fsmax_fastcall     ; capture NaN
    inc d
    jp Z,m32_fsmax_fastcall     ; capture overflow
    dec d
    rr d                        ; return exponent
    rr e
    ret                         ; return IEEE DEHL
