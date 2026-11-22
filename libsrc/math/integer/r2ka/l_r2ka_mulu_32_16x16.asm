;
;  feilipu, 2023 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

PUBLIC l_r2ka_mulu_32_16x16

l_r2ka_mulu_32_16x16:

    ; multiplication of two 16-bit numbers into a 32-bit product
    ;
    ; enter : hl = 16-bit multiplier   = x
    ;         de = 16-bit multiplicand = y
    ;
    ; exit  : dehl = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, hl'


    ld bc,hl                    ; multiplier to bc
    ld hl',bc                   ; multiplier to hl'
    ld a,b                      ; save sign of multiplier

    mul                         ; signed multiply of BC and DE,
                                ; result in HL:BC

    rla                         ; test sign of multiplier
    jr NC,pos                   ; positive multiplier

    add hl,de                   ; adjust for negative multiplier

.pos
    rl de                       ; test sign of multiplicand
    jr NC,not_neg               ; continue if not negative

    ex de,hl'                   ; multiplier to de
    add hl,de                   ; adjust for negative multiplicand

.not_neg
    ex de,hl
    ld hl,bc                    ; result to dehl

    or a
    ret
