;
;  Copyright (c) 2020 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, August 2020
;
;-------------------------------------------------------------------------
; asm_am9511_fmul2 - z80, z180, z80n floating point multiply by 2
;-------------------------------------------------------------------------
; 
; Multiplication by 2 is incrementing the exponent. An easy optimisation.
;
;-------------------------------------------------------------------------

SECTION code_fp_am9511

PUBLIC asm_am9511_fmul2_fastcall

.asm_am9511_fmul2_fastcall
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
    ld hl,de

    rr d                        ; restore the sign
    ret                         ; return IEEE signed ZERO in DEHL

.infinity
    ld e,d                      ; use 0
    ld hl,de

    dec d                       ; 0xff
    rr d                        ; restore the sign
    rr e
    scf
    ret                         ; return IEEE signed INFINITY in DEHL

