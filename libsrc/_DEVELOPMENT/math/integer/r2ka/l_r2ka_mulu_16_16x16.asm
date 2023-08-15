;
;  feilipu, 2023 June
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

PUBLIC l_r2ka_mulu_16_16x16

l_r2ka_mulu_16_16x16:

    ; multiplication of two 16-bit numbers into a 16-bit product
    ;
    ; enter : hl = 16-bit multiplier
    ;         de = 16-bit multiplicand
    ;
    ; exit  : hl = 16-bit product
    ;         carry reset
    ;
    ; uses  : f, bc, de, hl

    ld bc,hl                    ; multiplier to bc

    mul                         ; signed multiply of BC and DE,
                                ; result in HL:BC

    ld hl,bc                    ; result to hl

    or a
    ret
