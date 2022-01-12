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

SECTION code_fp_am9511

PUBLIC asm_am9511_fpclassify

.asm_am9511_fpclassify
    ; enter : dehl  = float x
    ;
    ; exit  : dehl  = float x
    ;            a  = 0 if number
    ;               = 1 if zero
    ;               = 2 if nan
    ;               = 3 if inf
    ;
    ; uses  : af
    sla e
    rl d
    ld a,d
    rr d
    rr e

    ; Zero  -     sign  = whatever
    ;         exponent  = all 0s
    ;         mantissa  = whatever
    or a
    jr Z,zero

    ; Number -   sign  = whatever
    ;        exponent  = not all 1s
    ;        mantissa  = whatever
    cpl
    or a
    jr NZ,number

    ; Infinity - sign  = whatever
    ;        exponent  = all 1s
    ;         mantissa = all 0s
    ; NaN      - sign  = whatever
    ;        exponent  = all 1s
    ;        mantissa  = not 0

    ; So we could be NaN, or Inf here
    ld a,e
    rla
    or h
    or l
    ld a,3      ;Infinity
    ret Z

    dec a       ;It's NaN
    ret

.number
    xor    a
    ret

.zero
    inc    a
    ret

