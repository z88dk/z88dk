;
;  Copyright (c) 2015 Digi International Inc.
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, 2019 April
;  adapted for z80, z180, and z80n
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32_fsneg
PUBLIC m32_fszero
PUBLIC m32_fsmin
PUBLIC m32_fsmax
PUBLIC m32_fsnan

; here to negate a number in dehl
.m32_fsneg
    ld a,d
    xor 080h
    ld d,a
    ret

; here to return a legal zero of sign d in dehl
.m32_fszero
    ld a,d
    and 080h
    ld d,a
    ld e,0
    ld h,e
    ld l,e
    ret

; here to change underflow to a error floating zero
.m32_fsmin
    call m32_fszero

.m32_fseexit
    scf                     ; C set for error
    ret

; here to change overflow to floating infinity of sign d in dehl
.m32_fsmax
    ld a,d
    or 07fh                 ; max exponent
    ld d,a
    ld e,080h               ;floating infinity
    ld hl,0
    jr m32_fseexit


; here to change error to floating NaN of sign d in dehl
.m32_fsnan
    ld a,d
    or 07fh                 ; max exponent
    ld d,a
    ld e,0ffh               ;floating NaN
    ld h,e
    ld l,e
    jr m32_fseexit

