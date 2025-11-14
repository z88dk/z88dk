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

PUBLIC l_r2ka_mulu_24_16x8

l_r2ka_mulu_24_16x8:

    ; multiplication of 16-bit number and 8-bit number into a 24-bit product
    ;
    ; enter : hl = 16-bit multiplier   = x
    ;          e =  8-bit multiplicand = y
    ;
    ; exit  : ahl = 24-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    ld bc,hl                    ; multiplier to bc
    ld e,0                      ; extended 16 bit unsigned multiplicand

    mul                         ; signed multiply of BC and DE,
                                ; result in HL:BC

    ld a,l
    ld hl,bc                    ; result to ahl

    or a
    ret
