;
;  Copyright (c) 2015 Digi International Inc.
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;

SECTION code_clib
SECTION code_math

PUBLIC md32_fsneg
PUBLIC md32_fszero
PUBLIC md32_fsmin
PUBLIC md32_fsmax

; here to negate a number in bcde
.md32_fsneg
    ld a,b
    xor 080h
    ld b,a
    ret

; here to return a legal zero in bcde
.md32_fszero
    ld bc,0
    ld d,c
    ld e,c
    or a
    ret

; here to change underflow to a error floating zero
.md32_fsmin
    call md32_fszero
    jr eexit

; here to change overflow to floating infinity of sign b in bcde
.md32_fsmax
    ld a,b
    or 07fh                 ; max exponent
    ld b,a
    ld c,080h               ;floating infinity
    ld de,0

.eexit
    scf                     ; C for error
    ret

