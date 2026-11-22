;
;  Copyright (c) 2020 Phillip Stevens
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;  feilipu, May 2020
;
;-------------------------------------------------------------------------
;  asm_f16_int_f24 - z80 half float unpacked format conversion
;-------------------------------------------------------------------------
;
;  unpacked format: exponent in d, sign in e[7], mantissa in hl
;  return normalized result also in unpacked format
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_normalize

PUBLIC asm_f24_i8
PUBLIC asm_f24_i16

PUBLIC asm_f24_u8
PUBLIC asm_f24_u16

; convert signed char in l to _f24 in dehl
.asm_f24_i8
    ld a,l
    rla                         ; sign bit of a into C
    sbc a,a
    ld h,a                      ; now hl is sign extended

; convert integer in hl to _f24 in dehl
.asm_f24_i16
    ld d,142                    ; exponent
    ld e,h                      ; sign in e[7]
    bit 7,h                     ; test sign, negate if negative
    jp Z,asm_f24_normalize      ; straight to normalisation code
    xor a                       ; negate
    sub a,l
    ld l,a
    sbc a,a
    sub a,h
    ld h,a
    jp asm_f24_normalize        ; piggy back on normalisation code

; convert character in l to _f24 in dehl
.asm_f24_u8
    ld h,0

; convert unsigned integer in hl to _f24 in dehl
.asm_f24_u16
    ld d,142                    ; exponent
    res 7,e                     ; sign in e[7]
    jp asm_f24_normalize        ; piggy back on normalisation code

