;
;  feilipu, 2023 October
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------

IF __CPU_R4K__

SECTION code_clib
SECTION code_math

PUBLIC l_r4k_mulu_32_16x16

l_r4k_mulu_32_16x16:

    ; multiplication of two 16-bit numbers into a 32-bit product
    ;
    ; enter : hl = 16-bit multiplier   = x
    ;         de = 16-bit multiplicand = y
    ;
    ; exit  : dehl = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    ld bc,hl                    ; multiplier to bc

    mulu                        ; unsigned multiply of BC and DE,
                                ; result in HL:BC

    ex de,hl
    ld hl,bc                    ; result to dehl

    or a
    ret

ENDIF
