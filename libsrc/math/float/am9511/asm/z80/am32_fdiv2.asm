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
; asm_am9511_fdiv2 - am9511 floating point divide by 2
;-------------------------------------------------------------------------
; 
; Division by 2 is decrementing the exponent. An easy optimisation.
;
;-------------------------------------------------------------------------

SECTION code_fp_am9511

PUBLIC asm_am9511_fdiv2_fastcall

.asm_am9511_fdiv2_fastcall
    sla e                       ; get exponent in d
    rl d                        ; put sign in C
    jr Z,zero_legal             ; return IEEE zero

    dec d                       ; divide by 2
    jr Z,zero_underflow         ; capture underflow zero

    rr d                        ; return sign and exponent
    rr e
    ret                         ; return IEEE DEHL

.zero_legal
    ld e,d                      ; use 0
    ld h,d
    ld l,d        
    rr d                        ; restore the sign
    ret                         ; return IEEE signed ZERO in DEHL

.zero_underflow
    ld e,d                      ; use 0
    ld h,d
    ld l,d
    rr d                        ; restore the sign
    scf
    ret                         ; return IEEE signed ZERO in DEHL
