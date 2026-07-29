;
;  feilipu, 2020 / 2026 July (8085)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;

SECTION code_clib
SECTION code_fp_math16

EXTERN  asm_f24_f16

PUBLIC  asm_f16_classify

.asm_f16_classify
    ; enter :   hl  = half x
    ;
    ; exit  :   hl  = half x
    ;            a  = 0 if number
    ;               = 1 if zero
    ;               = 2 if nan
    ;               = 3 if inf
    ;
    ; uses  : af, de
    push hl
    call asm_f24_f16

    ld a,d
    or a
    jr Z,zero

    cpl
    or a
    jr NZ,number

    ld a,h
    or l
    ld a,3                      ; Infinity
    pop hl
    ret Z

    dec a                       ; NaN
    ret

.number
    pop hl
    xor a
    ret

.zero
    pop hl
    inc a
    ret
