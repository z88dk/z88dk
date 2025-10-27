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

SECTION code_clib
SECTION code_fp_am9511

PUBLIC asm_am9511_neg
PUBLIC asm_am9511_zero
PUBLIC asm_am9511_zero_hlde
PUBLIC asm_am9511_min
PUBLIC asm_am9511_max
PUBLIC asm_am9511_nan
PUBLIC asm_am9511_eexit

; here to negate a number in dehl
.asm_am9511_neg
    ld a,d
    xor $80
    ld d,a
    ret


; here to return a legal zero of sign h in hlde
.asm_am9511_zero_hlde
    ex de,hl


; here to change underflow to a error floating zero
.asm_am9511_min


; here to return a legal zero of sign d in dehl
.asm_am9511_zero
    ld a,d
    and 080h
    ld d,a
    ld hl,0
    ld e,h
    ret


; here to change error to floating NaN of sign d in dehl
.asm_am9511_nan
    ld a,d
    or 07fh                 ; max exponent
    ld d,a
    ld e,0ffh               ;floating NaN
    ld h,e
    ld l,e
    jr asm_am9511_eexit


; here to change overflow to floating infinity of sign d in dehl
.asm_am9511_max
    ld a,d
    or 07fh                 ; max exponent
    ld d,a
    ld e,080h               ;floating infinity
    ld hl,0


.asm_am9511_eexit
    scf                     ; C set for error
    ret
