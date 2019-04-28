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

; here to negate a number in dehl
.md32_fsneg
    ld a,d
    xor 080h
    ld d,a
    ret

; here to return a legal zero in dehl
.md32_fszero
    ld de,0
    ld h,d
    ld l,d
    or a
    ret

; here to change underflow to a error floating zero
.md32_fsmin
    call md32_fszero
    jr eexit

; here to change overflow to floating infinity of sign d in dehl
.md32_fsmax
    ld a,d
    or 07fh                 ; max exponent
    ld d,a
    ld e,080h               ;floating infinity
    ld hl,0

.eexit
    scf                     ; C set for error
    ret

