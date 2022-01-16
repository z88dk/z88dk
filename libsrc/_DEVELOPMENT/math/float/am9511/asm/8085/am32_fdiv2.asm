;
;  Copyright (c) 2022 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, January 2022
;
;-------------------------------------------------------------------------
; asm_am9511_fdiv2 - am9511 floating point divide by 2
;-------------------------------------------------------------------------
; 
; Division by 2 is decrementing the exponent. An easy optimisation.
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_am9511_fdiv2_fastcall

.asm_am9511_fdiv2_fastcall

    rl de                       ; get exponent in d

    inc d
    dec d
    jp Z,zero_legal             ; return IEEE zero

    dec d                       ; divide by 2
    jr Z,zero_underflow         ; capture underflow zero

    ld a,d
    rra                         ; return sign and exponent
    ld d,a

    ld a,e
    rra                         ; return exponent and mantissa
    ld e,a

    ret                         ; return IEEE DEHL

.zero_legal
    ld e,d                      ; use 0
    ld hl,de

    ld a,d
    rra                         ; restore the sign and exponent
    ld d,a

    ret                         ; return IEEE signed ZERO in DEHL

.zero_underflow
    ld e,d                      ; use 0
    ld hl,de

    ld a,d
    rra                         ; restore the sign and exponent
    ld d,a

    scf
    ret                         ; return IEEE signed ZERO in DEHL
