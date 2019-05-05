;
;  Copyright (c) 2015 Digi International Inc.
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, 2019 April
;  adapted for z80, z180, and z80-zxn
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

PUBLIC md32_fsneg_fastcall
PUBLIC md32_fszero_fastcall
PUBLIC md32_fsmin_fastcall
PUBLIC md32_fsmax_fastcall

; here to negate a number in dehl
.md32_fsneg_fastcall
    ld a,d
    xor 080h
    ld d,a
    ret

; here to return a legal zero in dehl
.md32_fszero_fastcall
    ld de,0
    ld h,d
    ld l,d
    or a
    ret

; here to change underflow to a error floating zero
.md32_fsmin_fastcall
    call md32_fszero_fastcall
    jr md32_fseexit

; here to change overflow to floating infinity of sign d in dehl
.md32_fsmax_fastcall
    ld a,d
    or 07fh                 ; max exponent
    ld d,a
    ld e,080h               ;floating infinity
    ld hl,0

.md32_fseexit
    scf                     ; C set for error
    ret

